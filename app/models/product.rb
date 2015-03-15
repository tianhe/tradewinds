class Product
  include Mongoid::Document

  field :brand, type: String
  field :model, type: String
  field :color, type: String
  field :carrier, type: String
  field :specs, type: String
  field :capacity, type: String
  field :unlocked, type: Boolean
  
  validates :brand, :model, :capacity, :color, presence: true

  has_many :listings
end