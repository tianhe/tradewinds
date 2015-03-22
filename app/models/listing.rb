class Listing
  include Mongoid::Document
  
  field :title, type: String
  field :description, type: String
  field :list_time, type: Date
  field :url, type: String
  field :city, type: String
  field :neighborhood, type: String

  field :listing_price, type: Float, default: 0
  field :transaction_price, type: Float, default: 0

  field :condition, type: String
  field :cracked_screen, type: Boolean
  field :scratches, type: Boolean
  field :cash, type: Boolean
  field :verified, type: Boolean, default: false

  # belongs_to :product
  field :brand, type: String
  field :model, type: String
  field :color, type: String
  field :carrier, type: String
  field :specs, type: String
  field :capacity, type: String
  field :unlocked, type: Boolean

  # belongs_to :source
  field :source, type: Boolean
    
  validates :url, presence: true, uniqueness: true  

end