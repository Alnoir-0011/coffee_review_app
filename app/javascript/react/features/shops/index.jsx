import React, { useState } from 'react'
import ShopsMap from './components/ShopsMap';
import ShopList from './components/ShopList';
import ShopReviews from './components/ShopReviews'
import SearchForm from './components/SearchForm';
import LocationSearchButton from './components/LocationSearchButton';

const initialState = { name: '', page: 1 , lat: 35.6809591, lng: 139.7673068 }

export default function Shops() {
  const [focus, setFocus] = useState({id: 0 });
  const [searchCondition, setSearchCondition] = useState({});

  return(
    <>
      <div className='d-flex justify-content-between mb-3'>
        <h1 className='mb-0'>店舗一覧</h1>
        <LocationSearchButton setSearchCondition={setSearchCondition} />
      </div>
      <ShopsMap searchCondition={searchCondition} setFocus={setFocus} />
      <SearchForm useSearch={() => ([searchCondition, setSearchCondition])} />
      <ShopReviews focus={focus} />
    </>
  )
}
