class Listing
  include Mongoid::Document
  
  field :listing_price, type: Float, default: 0
  field :transaction_price, type: Float, default: 0
  field :list_time, type: Date
  field :url, type: String
  field :condition, type: String
  field :description, type: String
  field :title, type: String
  field :city, type: String
  field :neighborhood, type: String
  field :verified, type: Boolean, default: false
  
  validates :url, presence: true, uniqueness: true  

  belongs_to :product
  belongs_to :source
end