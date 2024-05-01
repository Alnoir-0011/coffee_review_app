import { Controller } from "@hotwired/stimulus"
import Swiper from "swiper/bundle"

// Connects to data-controller="swiper"
export default class extends Controller {
  connect() {
    const swiper = new Swiper('.swiper', {
      // centerInsufficientSlides: true,
      centeredSlides: true,
      // centeredSlidesBounds: true,
      slidesPerView: "auto",

      autoplay: {
        delay: 4000,
        disableOnInteraction: false,
        waitForTransition: false,
      },
      // Optional parameters
      loop: true,
      // loopAdditionalSlides: 3,
    
      // If we need pagination
      pagination: {
        el: '.swiper-pagination',
        clickable: true,
      },

      // Navigation arrows
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },

      // And if we need scrollbar
      // scrollbar: {
      //   el: '.swiper-scrollbar',
      // },
    });
  }
}
