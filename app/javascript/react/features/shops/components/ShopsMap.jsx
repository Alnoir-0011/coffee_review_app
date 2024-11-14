import React, { useState, useEffect, useRef } from 'react';
import { Loader } from '@googlemaps/js-api-loader';
import { renderToString } from 'react-dom/server';

import Infowindow from './Infowindow';

const initialLatLng = { lat: 35.6809591, lng: 139.7673068 } // 東京駅

export default function ShopsMap({ searchCondition, setFocus }) {
  const mapRef = useRef();
  const [markers, setMarkers] = useState([]);
  const [explanation, setExplanation] = useState('東京駅周辺の店舗');

  const loader = new Loader({
    apiKey: document.head.querySelector("meta[name=map_api]").content,
    version: "weekly",
    libraries: ["marker", "places"]
  })

  useEffect(() => {
    (async () => {
      // 初回レンダリングのみ実行
      if (!mapRef.current) {
        const { Map } = await loader.importLibrary("maps");

        const newMap = new Map(document.getElementById('map'), {
          center: initialLatLng,
          zoom: 13,
          mapId: "SHOP_INDEX",
        });

        mapRef.current = newMap;
      }
      const map = mapRef.current;
      let shops;
      const { AdvancedMarkerElement, PinElement } = await loader.importLibrary("marker");
      try {
        const params = new URLSearchParams(searchCondition);
        const response = await fetch(`/shops?CONTENT_TYPE=application/json&${params.toString()}`)

        if (response.ok) {
          const data = await response.json();
          shops = data['data'];
        } else {
          window.alert('店舗を読み込めませんでした')
        }
      } catch(e) {
        window.alert('リクエストに失敗しました')
      }
      // 古いマーカーの削除
      markers.map(marker => { marker.setMap(null) })

      const newMarkers = shops.map(shop => {
        const glyphImg = document.createElement("img");
        glyphImg.src = 'images/map_icon.png'
        const glyphSvgPinElement = new PinElement({
          glyph: glyphImg,
          background: "#641F1F",
          borderColor: "#641F1F"
        });

        const marker = new AdvancedMarkerElement({ map, position: { lat: shop.attributes.latitude, lng: shop.attributes.longitude }, content: glyphSvgPinElement.element });

        const infowindow = new google.maps.InfoWindow({
          content: renderToString(<Infowindow shop={shop} />),
          ariaLabel: shop.attributes.name,
        });

        marker.addListener('click', () => {
          setFocus(shop);
          infowindow.open({
            anchor: marker,
            map,
          });
          map.setCenter(marker.position);
          map.setZoom(17);
        });
        return marker;
      })
      setMarkers(newMarkers);

      if('q[name_cont]' in searchCondition) {
        setExplanation(`${searchCondition['q[name_cont]']}を含む店舗`)
        if(newMarkers.length !== 0) {
          map.setZoom(10);
          map.setCenter(newMarkers[0].position);
        }
      }

      if('lat' in searchCondition) {
        setExplanation('現在地周辺の店舗')
        map.setZoom(13);
        map.setCenter({ lat: searchCondition["lat"], lng: searchCondition["lng"] })
      }
    })()
  },[searchCondition]);

  return (
    <>
      <h6>現在の表示内容:{explanation}</h6>
      <div id="map" className="mb-3" style={{ height: "37.5rem" }}></div>
    </>
  )
}
