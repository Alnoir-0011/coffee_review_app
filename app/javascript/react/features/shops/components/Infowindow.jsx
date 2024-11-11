import React from 'react';

export default function Infowindow({ shop }) {
  return (
    <>
      <h6 className="card-title">{shop.name}</h6>
      <p>{shop.address}</p>
    </>
  )
}