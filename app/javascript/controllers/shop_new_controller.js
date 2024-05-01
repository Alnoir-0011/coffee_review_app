import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader"

// Connects to data-controller="shop-new"
export default class extends Controller {
  static  targets = ["map", "input", "name", "placeId", "address", "lat", "lng"]

  connect() {
    const loader = new Loader({
      apiKey: document.head.querySelector("meta[name=map_api]").content,
      version: "weekly",
      libraries: ["marker", "places"]
    })

    loader
      .load()
      .then((google) => {
        const map = new google.maps.Map(this.mapTarget, {
          center: {
            lat: 35.6809591, lng: 139.7673068
          },
          zoom: 12,
          mapId: "NEW_SHOP_MAP"
        })

        const options = {
          componentRestrictions: { country: "jp" },
          fields: ["place_id", "geometry", "name", "formatted_address"],
          strictBounds: false,
        }

        const autocomplete = new google.maps.places.Autocomplete(this.inputTarget, options)
        autocomplete.bindTo("bounds", map)

        const marker = new google.maps.marker.AdvancedMarkerElement({
          map
        })

        autocomplete.addListener("place_changed",() => {
          const place = autocomplete.getPlace()
          if (!place.geometry || !place.geometry.location) {
            window.alert(place.name + I18n.message.no_deatails_availabel)
            return
          }

          if (place.geometry.viewport) {
            map.fitBounds(place.geometry.viewport)
          } else {
            map.setCenter(place.geometry.location)
            map.setZoom(17);
          }
          marker.position = place.geometry.location
      
          this.nameTarget.value = place.name
          this.placeIdTarget.value = place.place_id
          this.addressTarget.value = place.formatted_address.replace("日本、","")
          this.latTarget.value = place.geometry.location.lat()
          this.lngTarget.value = place.geometry.location.lng();
        });
      })
      .catch((e) => {
        console.error(e.message)
      })
  }
}
