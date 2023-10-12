import * as bootstrap from "bootstrap"
const initIndexMap = () => {
  if(document.getElementById("map-index")) {
    const geocoder = new google.maps.Geocoder();

    const currentLocationButton = document.getElementById("get-position");
    const currentLat = parseFloat(currentLocationButton.dataset.lat);
    const currentLng = parseFloat(currentLocationButton.dataset.lng);

    const map = new google.maps.Map(document.getElementById("map-index"), {
      center: {lat: currentLat || 35.6809591, lng: currentLng || 139.7673068},
      zoom: 9,
    });

    const list = document.getElementById("accordionShops");
    const listItems = list.children;
    const collapseList = Array.from(listItems).map((item) => {
      return new bootstrap.Collapse(item.firstElementChild.children[1], { toggle: false });
    });

    const markers = []
    for(let i = 0; i < listItems.length; i++) {
      markers[i] = new google.maps.Marker({
        position: new google.maps.LatLng(listItems[i].firstElementChild.dataset.lat, listItems[i].firstElementChild.dataset.lng),
        map: map,
      });

      const button = listItems[i].firstElementChild.firstElementChild.firstElementChild;
      button.addEventListener('click', (e) => {
        const targetLat = e.target.parentElement.parentElement.parentElement.parentElement.dataset.lat;
        const targetLng = e.target.parentElement.parentElement.parentElement.parentElement.dataset.lng;

        map.setCenter(new google.maps.LatLng(targetLat, targetLng));
        map.setZoom(17); 
      });

      google.maps.event.addListener(markers[i], 'click', () => {
        map.setCenter(markers[i].position);
        map.setZoom(17); 
        const rect = listItems[i].getBoundingClientRect();
        const elemtop = rect.top + list.scrollTop;
        list.scrollTop = elemtop;
        collapseList.forEach((collapse, index) => {
          if(index == i) {
            collapse.show();
          }else{
            collapse.hide();
          };
        });
      });
    };
  };
};


document.addEventListener('DOMContentLoaded', () => {
    initIndexMap();
});

document.addEventListener('turbo:load', () => {
    initIndexMap();
});