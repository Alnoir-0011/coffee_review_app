import React, { useState } from 'react';
// import ReviewCard from './ReviewCard';

const ShopCard = ({ shop, isFocused, setFocus }) => {
  const [isOpen, setIsOpen] = useState(false);

  console.log('card render')
  console.log(isOpen)

  const toggle = () => {
    setFocus(shop)
  }

  return (
    <div className='card mb-2'>
      <div className='card-body'>
        <button className='accordion-button' onClick={toggle}>
          <h5 className='card-title'>{shop.name}</h5>
        </button>
        { isFocused ? (
          <div>
            <p className='mb-2'>{shop.address}</p>
            <div className='d-flex justify-content-between mb-1 align-align-items-center'>
              <a href={`${shop.google_map_uri}`} target="_blank">googlemapで見る</a>
              <button className='btn btn-dark'>
                <i className='bi bi-clipboard2-fill' />
              </button>
            </div>
          </div>
        ) : '' }
      </div>
    </div>
  )
}

export default ShopCard;