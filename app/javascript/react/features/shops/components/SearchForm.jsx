import React, { useState } from 'react';

export default function SearchForm({ useSearch }) {
  const [name, setName] = useState('')
  const [searchCondition, setSearchCondition] = useSearch();
  const submitHandler = (e) => {
    e.preventDefault();
    setSearchCondition({ 'q[name_cont]': name });
  }

  return (
    <form className='mb-3' onSubmit={submitHandler}>
      <div className='input-group'>
        <input type="text" className='form-control' placeholder='店舗名から探す' value={name} onChange={(e) => setName(e.target.value)} required />
        <button className='btn btn-secondary'>検索</button>
      </div>
    </form>
  )
}