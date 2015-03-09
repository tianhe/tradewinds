class Location
  include Mongoid::Document

  field :neighborhood, type: String
  field :city, type: String

  has_many :listings
end