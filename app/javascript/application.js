// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

import "trix"
import "@rails/actiontext"

// The eventListener that controls the loading animation
document.addEventListener("turbo:load", () => {
  const triggerBtn = document.querySelector('#generate-material-btn');
  const loader = document.querySelector('.loading-screen');

  // Safety check: only run this code if the button and loader actually exist on this page
  if (!triggerBtn || !loader) return;

  // 1. Show the loader immediately when the link is clicked
  triggerBtn.addEventListener('click', () => {
    loader.classList.add('active');
  });

  // 2. Hide the loader if the user hits the browser "Back" button later
  document.addEventListener("turbo:before-cache", () => {
    loader.classList.remove('active');
  });
});
