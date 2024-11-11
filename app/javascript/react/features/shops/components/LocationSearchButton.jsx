import React from 'react';

export default function LocationSearchButton({ setSearchCondition }) {

  const getCurrentLocation = () => {
    try{
      navigator.geolocation.getCurrentPosition(success, fail);
    }catch(e){
      alert(I18n.message.your_browser_does_not_support);
    };
  }

  const success = (pos) => {
    const lat = pos.coords.latitude;
    const lng = pos.coords.longitude;

    setSearchCondition({ "lat": lat, "lng": lng })
  };

  const fail = (pos) => {
    alert(I18n.message.fail_get_location + pos);
  }

  return (
    <button onClick={getCurrentLocation} className='btn btn-secondary my-2'>現在地から探す</button>
  )
}