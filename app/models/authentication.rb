class Authentication
  include Mongoid::Document
  field :provider,      type: String,  default: ""
  field :uid,           type: String,  default: ""
  field :user_id,       type: Integer, default: ""
  field :access_token,  type: String,  default: ""
  field :oauth_token,   type: String,  default: ""
  field :oauth_expires_at, type: String,  default: ""
  
  belongs_to  :user

  validates :uid, presence: true
  validates :provider, presence: true
  validates :uid, uniqueness: { scope: :provider, message: 'should have single uid per provider' } 

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |authentication|
      authentication.provider = auth.provider
      authentication.uid = auth.uid
      authentication.oauth_token = auth.credentials.token
      authentication.oauth_expires_at = Time.at(auth.credentials.expires_at)
    end
  end
end
