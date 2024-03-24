import { Tooltip } from "bootstrap";

const initTooltip = () => {
  if(document.querySelectorAll('[data-bs-toggle="tooltip"]')) {
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new Tooltip(tooltipTriggerEl));
  };
};

document.addEventListener('DOMContentLoaded', initTooltip);
document.addEventListener('turbo:load', initTooltip);
document.addEventListener('turbo:frame', initTooltip);