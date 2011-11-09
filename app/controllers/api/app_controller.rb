class Api::AppController < ActionController::Base # API接口
  layout nil #api不需要layout,只产生json和xml格式
  before_filter :check_http_authorization
  before_filter :check_oauth_authorization
  before_filter :load_resource

  respond_to :json,:xml

  def index
    respond_with(@collection) do |format|
      format.json { render json: @collection.to_json(collection_serialization_options) }
      format.xml  { render  xml: @collection.to_xml(collection_serialization_options) }
    end
  end

  def show
    respond_with(@object) do |format|
      format.json { render json: @object.to_json(object_serialization_options) }
      format.xml { render  xml:  @object.to_xml(object_serialization_options) }
    end
  end

  def update
    if @object.update_attributes(params[object_name])
      respond_with(@object) do |format|
        format.json { render json: @object.to_json(object_serialization_options) }
        format.xml { render  xml:  @object.to_xml(object_serialization_options) }
      end
    else
      respond_with(@object.errors,status: 422)
    end
  end

  def create
    if @object.save
      respond_with(@object) do |format|
        format.json { render json: @object.to_json(object_serialization_options) }
        format.xml { render xml: @object.to_xml(object_serialization_options) }
      end
    else
      respond_with(@object.errors,status: 422)
    end
  end

  def destroy
    @object.destroy
    render nothing: true
  end

  protected
  def model_class
    controller_name.classify.constantize
  end

  def object_name
    controller_name.singularize
  end

  def load_resource
    if member_action?
      @object ||= load_resource_instance
      instance_variable_set("@#{object_name}", @object)
    else
      @collection ||= collection
      instance_variable_set("@#{controller_name}", @collection)
    end
  end

  def load_resource_instance
    if new_actions.include?(params[:action].to_sym)
      build_resource
    elsif params[:id]
      find_resource
    end
  end

  #默认所有资源都从shop下面查找
  def parent
    Shop.at(request.host)
  end

  def find_resource
    if parent.present?
      parent.send(controller_name).find(params[:id])
    else
      model_class.includes(eager_load_associations).find(params[:id])
    end
  end

  def build_resource
    if parent.present?
      parent.send(controller_name).build(params[object_name])
    else
      model_class.new(params[object_name])
    end
  end

  def collection
    return @search unless @search.nil?
    params[:search] = {} if params[:search].blank?
    params[:search][:meta_sort] = 'created_at.desc' if params[:search][:meta_sort].blank?

    scope = parent.present? ? parent.send(controller_name) : model_class.scoped

    @search = scope.metasearch(params[:search]).relation.limit(100)
    @search
  end

  #此参数用于加载集合to_json所要带的参数，例如except,include
  def collection_serialization_options
    {}
  end

  #同上理
  def object_serialization_options
    {}
  end

  def eager_load_associations
    nil
  end

  def object_errors
    {:errors => object.errors.full_messages}
  end

  def collection_actions
    [:index]
  end

  def member_action?
    !collection_actions.include? params[:action].to_sym
  end

  def new_actions
    [:new, :create]
  end

  private
  def check_http_authorization
    unless session[:shop]
      myshopqi = Shop.at( request.host)
      authenticate_or_request_with_http_basic do |username, password|
        if myshopqi.api_clients.exists?(api_key: username,password: password)
          session[:shop] ||=  myshopqi.as_json(only: [:deadline, :created_at, :updated_at, :name])['shop']
        else
          render json: {error: '[API] Invalid API key or permission token (unrecognized login or wrong password)'} , status: 401
        end
      end
    end
  end

  def check_oauth_authorization
    unless session[:shop]
      token = OAuth2::Provider.access_token(nil, [], request)
      unless token.valid?
        render json: {error: '[API] Invalid API key or permission token (unrecognized login or wrong password)'} , status: 401
      else
        session[:shop] ||= token.owner.as_json(only: [:deadline, :created_at, :updated_at, :name])['shop']
      end
    end
  end

  #用于处理控制器action的禁止访问
  def access_dennied
    render text: 'Access Dennied', status: 401
  end
end
