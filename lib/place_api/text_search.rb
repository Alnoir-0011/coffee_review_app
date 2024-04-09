def get_coffee_shop_from_viewport(lat, lng, lat_gap, lng_gap)
  uri = URI.parse('https://places.googleapis.com/v1/places:searchText')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === 'https'

  params = {
    'textQuery' => 'コーヒー豆 販売店 焙煎所',
    'languageCode' => 'ja',
    'regionCode' => 'JP',
    'locationRestriction' => {
      'rectangle' => {
        'low' => {
          'latitude' => lat,
          'longitude' => lng
        },
        'high' => {
          'latitude' => lat + lat_gap,
          'longitude' => lng + lng_gap
        }
      }
    }
  }

  headers = {
    'Content-Type' => 'application/json',
    'X-Goog-Api-Key' => ENV['PLACE_API_KEY'],
    'X-Goog-FieldMask' => 'places.displayName,places.formattedAddress,places.id,places.location,places.googleMapsUri'
  }

  response = http.post(uri.path, params.to_json, headers)

  case response

  when Net::HTTPOK
    p 'textsearch successful'
    res_body = JSON.parse(response.body)
    return [] if res_body.empty?

    res_body['places']

  when Net::HTTPClientError
    p "client error #{JSON.parse(response.body)['error']['message']}"
    []
  else
    p "error status: #{response.code}"
    []
  end
end

def save_shops(places)
  places.each do |place|
    next if Shop.find_by(place_id: place['id'])

    p "found #{place['displayName']['text']}"
    Shop.create!(name: place['displayName']['text'], address: place['formattedAddress'], latitude: place['location']['latitude'].to_f,
                 longitude: place['location']['longitude'].to_f, place_id: place['id'], google_map_uri: place['googleMapsUri'])
    p "create #{place['displayName']['text']}"
  end
end
