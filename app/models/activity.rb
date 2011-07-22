class Activity < ActiveRecord::Base
  def self.log(record)
    Activity.create record.
  end
end
