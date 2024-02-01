const googleAnalytics = () => {
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-06DY2R97SP');
};

document.addEventListener('DOMContentLoaded',() => {
  googleAnalytics();
});

document.addEventListener('turbo:load', () => {
  googleAnalytics();
});

document.addEventListener('turbo:frame', () => {
  googleAnalytics();
});