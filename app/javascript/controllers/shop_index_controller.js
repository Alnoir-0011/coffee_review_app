import { Controller } from "@hotwired/stimulus"
import { Collapse } from "bootstrap"
import { Loader } from "@googlemaps/js-api-loader"

// Connects to data-controller="shop-index"
export default class extends Controller {
  static targets = ['map', 'list', 'shop', 'location', 'lat', 'lng']
  connect() {
    const collapseList = this.shopTargets.map(item => new Collapse(item, { toggle: false }));

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
            lat: parseFloat(this.latTarget.value) || 35.6809591,
            lng: parseFloat(this.lngTarget.value) || 139.7673068
          },
          zoom: 13,
          mapId: "SHOPS_MAP"
        })

        const markers = this.shopTargets.map(item => new google.maps.marker.AdvancedMarkerElement({
          map: map,
          position: {
            lat: parseFloat(item.parentElement.dataset.lat),
            lng: parseFloat(item.parentElement.dataset.lng)
          }
        }))

        markers.forEach((marker, i) => {
          marker.addListener("click", () => {
            map.setZoom(17)
            map.setCenter(marker.position)
            collapseList.forEach((collapse, index) => {
              if(index === i) {
                collapse.show()
              }else{
                collapse.hide()
              };
            })
            this.listTarget.scrollTop = 66 * i
          })
        })

        const collapseButtons = this.shopTargets.map(item => item.parentElement.firstElementChild.firstElementChild)
        collapseButtons.forEach((button) => {
          button.addEventListener('click', (e) => {
            const latLng = new google.maps.LatLng(button.parentElement.parentElement.dataset.lat, button.parentElement.parentElement.dataset.lng)
            map.setCenter(latLng)
            map.setZoom(17)
          })
        })
      })
      .catch((e) => {
        console.error(e.message)
      })
  }
}
