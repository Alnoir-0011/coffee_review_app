import React from 'react';

export default function Infowindow({ shop }) {
  return (
    <>
      <h6 className="card-title">{shop.attributes.name}</h6>
      <p className='mb-2'>{shop.attributes.address}</p>
      <a href={shop.attributes.google_map_uri} target='_blank'>google mapで見る</a>
    </>
  )
}