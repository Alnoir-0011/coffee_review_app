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
      alert(I18n.message.fail_get_location + pos);
    }

    try{
      navigator.geolocation.getCurrentPosition(success, fail);
    }catch(e){alert(I18n.message.your_browser_does_not_support);
    };
  }
}
