import React from 'react';
import { createRoot } from "react-dom/client";
import Shops from '../features/shops';

document.addEventListener('turbo:load', () => {
  const container = document.getElementById("shop_index");
  if (container) {
    const root = createRoot(container);
    root.render(<Shops />);
  }
})

