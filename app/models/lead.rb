class Lead < ActiveRecord::Base
  belongs_to :profile

  def create_or_update(params)
    
  end
end
