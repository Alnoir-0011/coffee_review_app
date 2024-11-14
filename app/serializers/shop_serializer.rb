class ShopSerializer
  include JSONAPI::Serializer
  attributes :name, :address, :latitude, :longitude, :google_map_uri
end
