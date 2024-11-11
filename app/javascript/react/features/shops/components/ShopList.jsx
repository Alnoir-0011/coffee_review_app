import React from 'react';
import ShopCard from './ShopCard';

export default function ShopList({ shops, useFocus }) {
  const [focus, setFocus] = useFocus();
  console.log('list rendered');
  return (
    <div className='overflow-y-auto' style={{ max_height: '25rem' }}>
      {shops.map(shop => (
        <ShopCard key={shop.id} shop={shop} isFocused={shop.id === focus.id} setFocus={setFocus} />
      ))}
    </div>
  )
}