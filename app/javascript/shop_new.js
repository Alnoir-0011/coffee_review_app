function initNewMap() {
  const geocoder = new google.maps.Geocoder()

  const map = new google.maps.Map(document.getElementById('map-new'), {
    center: {lat: 35.6809591, lng:139.7673068},
    zoom: 12,
  });

  const input = document.getElementById("pac-input");
  const formnName = document.getElementById("form-name");
  const formPlaceId = document.getElementById("form-place-id");
  const formAddress = document.getElementById("form-address");
  const formLat = document.getElementById("form-lat");
  const formLng = document.getElementById("form-lng");

  const options = {
    componentRestrictions: { country: "jp" },
    fields: ["place_id", "geometry", "name", "formatted_address"],
    strictBounds: false,
  };

  const autocomplete = new google.maps.places.Autocomplete(input, options);
  autocomplete.bindTo("bounds", map);

  const marker = new google.maps.Marker({
    map,
    anchorPoint: new google.maps.Point(0, -29),
  });

  autocomplete.addListener("place_changed",() => {
    marker.setVisible(false);
    const place = autocomplete.getPlace();
    if (!place.geometry || !place.geometry.location) {
      window.alert("No details available for input: '" + place.name + "'");
      return;
    };
    console.log(place);
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
      map.setZoom(17);
    };
    marker.setPosition(place.geometry.location);
    marker.setVisible(true);

    formnName.value = place.name;
    formPlaceId.value = place.place_id;
    formAddress.value = place.formatted_address.replace("日本、","");
    formLat.value = place.geometry.location.lat();
    formLng.value = place.geometry.location.lng();
  });
};

document.addEventListener('DOMContentLoaded', () => {
  if(document.getElementById("map-new")) {
    initNewMap();
  };
});

document.addEventListener('turbo:load', () => {
  // console.log('turbo');
  if(document.getElementById("map-new")) {
    initNewMap();
  };
});

document.addEventListener('turbo:render', () => {
  if(document.getElementById("map-new")) {
    initNewMap();
  };
});