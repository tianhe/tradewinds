class Authentication
  include Mongoid::Document
  field :provider,      type: String,  default: ""
  field :uid,           type: String,  default: ""
  field :user_id,       type: Integer, default: ""
  field :access_token,  type: String,  default: ""
  
  belongs_to  :user
end
