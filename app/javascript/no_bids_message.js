document.addEventListener('turbo:load', function() {
    const noBidsMessage = document.querySelector('.no-bids-message');
    const bidsList = document.querySelector('#bids');
  
    if (noBidsMessage && bidsList && bidsList.children.length > 0) {
      noBidsMessage.style.display = 'none';
    }
  });