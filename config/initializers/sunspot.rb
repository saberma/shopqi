module Sunspot
  module SessionProxy
    class ResqueSessionProxy < AbstractSessionProxy # 参考http://j.mp/r64ADZ
      attr_reader :search_session

      delegate :new_search, :search, :config,
                :new_more_like_this, :more_like_this,
                :delete_dirty, :delete_dirty?, :dirty?,
                :to => :search_session

      def initialize(search_session = Sunspot.session)
        @search_session = search_session
      end

      def rescued_exception(method, exception)
        $stderr.puts("Exception in SunspotSessionProxy\##{method}: #{exception.message}")
      end

      [:index!, :index, :remove!, :remove].each do |method|
        module_eval(<<-RUBY)
          def #{method}(*objects)
            missed_objects = []
            objects.each do |object|
              if(object.is_a? ActiveRecord::Base)
                Resque.enqueue SunspotWorker, :#{method}, {:class => object.class.name, :id => object.id }
              else
                missed_objects << object
              end
            end
            begin
              @search_session.#{method}(missed_objects) unless missed_objects.empty?
            rescue => e
              self.rescued_exception(:#{method}, e)
            end
          end
        RUBY
      end

      [:remove_by_id, :remove_by_id!].each do |method|
        module_eval(<<-RUBY)
          def #{method}(clazz, id)
            Resque.enqueue SunspotWorker, :remove, {:class => clazz, :id => id}
          end
        RUBY
      end

      def remove_all(clazz = nil)
        Resque.enqueue SunspotWorker, :remove_all, clazz.to_s
      end

      def remove_all!(clazz = nil)
        Resque.enqueue SunspotWorker, :remove_all, clazz.to_s
      end

      [:commit_if_dirty, :commit_if_delete_dirty, :commit].each do |method|
        module_eval(<<-RUBY)
          def #{method}
            Resque.enqueue(SunspotWorker, :commit) unless ::Rails.env == 'production'
          end
        RUBY
      end
    end
  end
end

Sunspot.session = Sunspot::SessionProxy::ResqueSessionProxy.new(Sunspot.session)
