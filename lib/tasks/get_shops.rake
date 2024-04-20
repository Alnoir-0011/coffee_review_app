require './lib/place_api/text_search'

namespace :get_shops do
  task get_shop_in_tokyo: :environment do
    reference_end_point = { lat: 35.82, lng: 139.93 }
    lat_gap = 0.03
    lng_gap = 0.014
    search_lat = 35.54

    while search_lat < reference_end_point[:lat]
      search_lng = 139.57

      while search_lng < reference_end_point[:lng]
        p "searching location #{search_lat}, #{search_lng}"
        search_result = get_coffee_shop_from_viewport(search_lat, search_lng, lat_gap, lng_gap)
        save_shops(search_result)
        search_lng += lat_gap
      end
      search_lat += lng_gap
    end

    p 'Finish get shop in Tokyo!!'
  end

  task get_shop_in_kanto: :environment do
    viewports = [
      { low: { lat: 35.3, lng: 139.3 }, high: { lat: 35.54, lng: 140.2 }, gap: { lat: 0.12, lng: 0.1 } },
      { low: { lat: 35.54, lng: 139.3 }, high: { lat: 35.82, lng: 139.57 }, gap: { lat: 0.14, lng: 0.09 } },
      { low: { lat: 35.54, lng: 139.93 }, high: { lat: 35.82, lng: 140.2 }, gap: { lat: 0.14, lng: 0.09 } },
      { low: { lat: 35.82, lng: 139.3 }, high: { lat: 35.92, lng: 140.2 }, gap: { lat: 0.1, lng: 0.1 } }
    ]

    viewports.each do |viewport|
      search_lat = viewport[:low][:lat]

      while search_lat < viewport[:high][:lat]
        search_lng = viewport[:low][:lng]

        while search_lng < viewport[:high][:lng]
          p "searching location #{search_lat}, #{search_lng}"
          search_result = get_coffee_shop_from_viewport(search_lat, search_lng, viewport[:gap][:lat],
                                                        viewport[:gap][:lng])
          save_shops(search_result)
          search_lng += viewport[:gap][:lng]
        end
        search_lat += viewport[:gap][:lat]
      end
    end

    p 'Finish get shop in capital city area!!'
  end
end
