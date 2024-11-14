import React, { useState, useEffect } from 'react';
import ReviewCard from './ReviewCard';

export default function ShopReviews({ focus }) {
  const [reviews, setReviews] = useState([])
  const [isLoading, setIsLoading] = useState(false)

  useEffect(() => {
    async function fetchReviews() {
      setIsLoading(true)
      try {
        const response = await fetch(`/shops/${focus.id}/reviews`)
  
        if(response.ok) {
          const data = await response.json();
          setReviews(data['data'])
        } else {
          window.alert('レビューを読み込めませんでした')
        }
      } catch(e) {
          window.alert('リクエストに失敗しました')
      } finally {
        setIsLoading(false)
      }
    }

    if (focus.id !== 0) {
      fetchReviews();
    }
  }, [focus])

  if (isLoading) {
    return (
      <div>loading</div>
    )
  }

  if (focus.id === 0) {
    return(
      <div></div>
    )
  }

  return (
    <div>
      <h3>{focus.attributes.name}の商品レビュー</h3>
      <div className='row g-2'>
        {reviews.length !== 0 ? reviews.map(review => (<ReviewCard key={review.id} review={review} />)) : <h5>レビューがまだありません</h5>}
      </div>
    </div>
  )
}