module PlaceDetails
  extend ActiveSupport::Concern

  included do
    def add_google_map_uri
      uri = URI.parse("https://places.googleapis.com/v1/places/#{place_id}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === 'https'

      headers = {
        'Content-Type' => 'application/json',
        'X-Goog-Api-Key' => ENV['PLACE_API_KEY'],
        'X-Goog-FieldMask' => 'googleMapsUri'
      }

      response = http.get(uri.path, headers)

      case response

      when Net::HTTPOK
        res_body = JSON.parse(response.body)
        self.google_map_uri = res_body['googleMapsUri'] if res_body.present?
      when Net::HTTPClientError
        p response.code
        p "client error: #{JSON.parse(response.body)['error']['message']}"
      else
        p "error status: #{response.code}"
      end
    end
  end
end
