import React from 'react';

export default function ReviewCard({ review }) {
  return (
    <div className='col-12 col-lg-4 text-decoration-none'>
      <div className='card h-100'>
        <div className='card-body'>
          <h5 className='card-title'>{review.title}</h5>
          {/* <h6 className='card-subtitle mb-2 text-body-secondary'>{review.bean.name}</h6> */}
          <p className='card-text'>{review.content.slice(0, 20) + '...'}</p>
        </div>
      </div>
    </div>
  )
}