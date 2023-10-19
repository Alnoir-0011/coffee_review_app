import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";

// Connects to data-controller="location"
export default class extends Controller {
  current() {
    const success = (pos) => {
      const lat = pos.coords.latitude;
      const lng = pos.coords.longitude;

      Turbo.visit(`/shops?lat=${lat}&lng=${lng}`)
    };

    const fail = (pos) => {
      alert('位置情報の取得に失敗しました。エラーコード：'+pos);
    }

    try{
      navigator.geolocation.getCurrentPosition(success, fail);
    }catch(e){alert("お使いのブラウザは対応していません。");
    };
  }
}
