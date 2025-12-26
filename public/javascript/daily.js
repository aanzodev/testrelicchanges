// Daily Game Feature
(function() {
  'use strict';

  console.log('Daily game script loaded');

  // Get daily game based on date
  function getDailyGame() {
    // Check if games array exists
    if (typeof games === 'undefined' || !games || games.length === 0) {
      console.warn('Games array not available for daily game');
      return null;
    }

    // Use current date as seed for consistent daily selection
    const today = new Date();
    const dateString = `${today.getFullYear()}-${today.getMonth() + 1}-${today.getDate()}`;
    
    // Simple hash function to convert date to index
    let hash = 0;
    for (let i = 0; i < dateString.length; i++) {
      hash = ((hash << 5) - hash) + dateString.charCodeAt(i);
      hash = hash & hash;
    }
    
    const index = Math.abs(hash) % games.length;
    console.log('Daily game selected:', games[index].name);
    return games[index];
  }

  // Get countdown to next day
  function getCountdownToNextDay() {
    const now = new Date();
    const tomorrow = new Date(now);
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(0, 0, 0, 0);
    
    const diff = tomorrow - now;
    
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((diff % (1000 * 60)) / 1000);
    
    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }

  // Format date for display
  function formatDate() {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    const today = new Date();
    const dayName = days[today.getDay()];
    const monthName = months[today.getMonth()];
    const date = today.getDate();
    
    return `${dayName}, ${monthName} ${date}`;
  }

  // Create and render daily game card
  function renderDailyGame() {
    console.log('Rendering daily game card...');
    
    const dailyGame = getDailyGame();
    
    if (!dailyGame) {
      console.warn('Could not get daily game');
      return;
    }

    // Check if we're on the home page
    const homeContent = document.getElementById('content-home');
    if (!homeContent || homeContent.style.display === 'none') {
      console.log('Not on home page, skipping daily game render');
      return;
    }

    // Check if card already exists
    let card = document.getElementById('daily-game-card');
    
    if (!card) {
      card = document.createElement('div');
      card.id = 'daily-game-card';
      card.className = 'daily-game-card';
      document.body.appendChild(card);
      console.log('Daily game card created');
    }

    // Build card HTML
    card.innerHTML = `
      <div class="daily-game-header">
        <svg class="daily-game-icon" viewBox="0 0 24 24" fill="currentColor">
          <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"/>
        </svg>
        <div>
          <h3 class="daily-game-title">Daily Game</h3>
          <div class="daily-game-date">${formatDate()}</div>
        </div>
      </div>
      
      <img src="${dailyGame.image}" alt="${dailyGame.name}" class="daily-game-image" onerror="this.src='others/assets/relic.webp'" />
      
      <h4 class="daily-game-name">${dailyGame.name}</h4>
      <p class="daily-game-description">${dailyGame.description || 'Play this featured game of the day!'}</p>
      
      <button class="daily-game-play-btn" data-game-id="${dailyGame.id}">
        Play Now
      </button>
      
      <div class="daily-game-countdown">
        <span class="countdown-label">Next in:</span>
        <span class="countdown-time" id="daily-countdown">${getCountdownToNextDay()}</span>
      </div>
    `;

    // Add click handler for play button
    const playBtn = card.querySelector('.daily-game-play-btn');
    playBtn.addEventListener('click', function() {
      console.log('Daily game play button clicked');
      if (typeof playGame === 'function') {
        playGame(dailyGame);
      } else if (typeof window.playGame === 'function') {
        window.playGame(dailyGame);
      } else {
        console.warn('playGame function not available');
      }
    });

    // Update countdown every second
    updateCountdown();
    
    console.log('Daily game card rendered successfully');
  }

  // Update countdown timer
  function updateCountdown() {
    const countdownEl = document.getElementById('daily-countdown');
    
    if (countdownEl) {
      countdownEl.textContent = getCountdownToNextDay();
    }
    
    setTimeout(updateCountdown, 1000);
  }

  // Show/hide card based on current page
  function handlePageChange() {
    const card = document.getElementById('daily-game-card');
    const homeContent = document.getElementById('content-home');
    
    if (card && homeContent) {
      if (homeContent.style.display !== 'none') {
        card.style.display = 'block';
      } else {
        card.style.display = 'none';
      }
    }
  }

  // Initialize when DOM is ready
  function init() {
    console.log('Initializing daily game feature...');
    
    // Wait a bit to ensure games array is loaded
    if (typeof games === 'undefined' || !games || games.length === 0) {
      console.log('Waiting for games to load...');
      setTimeout(init, 500);
      return;
    }
    
    renderDailyGame();
    
    // Listen for page changes
    document.addEventListener('click', function(e) {
      if (e.target.closest('.sidebar-link')) {
        setTimeout(handlePageChange, 100);
      }
    });
    
    console.log('Daily game feature initialized successfully');
  }

  // Start initialization
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Refresh daily game at midnight
  function checkForNewDay() {
    const now = new Date();
    if (now.getHours() === 0 && now.getMinutes() === 0) {
      renderDailyGame();
    }
  }

  setInterval(checkForNewDay, 60000); // Check every minute

})();