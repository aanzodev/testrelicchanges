document.addEventListener('DOMContentLoaded', function() {
  console.log('Render script loaded');
  
  if (typeof games === 'undefined') {
    console.error('Games array not found! Make sure gms.js is loaded first.');
    return;
  }
  
  console.log(`Found ${games.length} games to render`);
  
  function renderCarousel() {
    const carouselTrack = document.getElementById('carousel-track-top');
    if (!carouselTrack) {
      console.warn('Carousel track not found');
      return;
    }
    
    // Get playable games (filter out Feedback)
    const playableGames = games.filter(game => game.name !== "Feedback");
    
    // Duplicate games to create seamless loop
    const allGames = [...playableGames, ...playableGames];
    
    allGames.forEach(game => {
      const card = document.createElement('div');
      card.className = 'game-card carousel-card';
      card.innerHTML = `
        <img src="${game.image}" alt="${game.name}" loading="lazy">
        <div class="game-card-title">${game.name}</div>
      `;
      
      card.addEventListener('click', () => {
        if (game.name === "Feedback") {
          window.open(game.url, '_blank');
        } else {
          loadGame(game);
        }
      });
      
      carouselTrack.appendChild(card);
    });
    
    console.log(`Rendered ${allGames.length} carousel cards`);
  }
  
  // ===== GAMES PAGE =====
  function renderGames(gamesToRender = games) {
    const gameList = document.getElementById('game-list');
    if (!gameList) {
      console.warn('Game list container not found');
      return;
    }
    
    gameList.innerHTML = '';
    
    gamesToRender.forEach(game => {
      const card = document.createElement('div');
      card.className = 'game-card';
      card.innerHTML = `
        <img src="${game.image}" alt="${game.name}" loading="lazy">
        <div class="game-card-title">${game.name}</div>
      `;
      
      card.addEventListener('click', () => {
        if (game.name === "Feedback") {
          window.open(game.url, '_blank');
        } else {
          loadGame(game);
        }
      });
      
      gameList.appendChild(card);
    });
    
    console.log(`Rendered ${gamesToRender.length} game cards`);
  }
  
  // ===== EMULATED GAMES PAGE =====
  function renderEmulatedGames(gamesToRender = emulatedGames) {
    const emulatedList = document.getElementById('emulated-list');
    if (!emulatedList) {
      console.warn('Emulated list container not found');
      return;
    }
    
    if (typeof emulatedGames === 'undefined') {
      console.error('emulatedGames array not found');
      return;
    }
    
    emulatedList.innerHTML = '';
    
    gamesToRender.forEach(game => {
      const card = document.createElement('div');
      card.className = 'game-card';
      card.innerHTML = `
        <img src="${game.image}" alt="${game.name}" loading="lazy">
        <div class="game-card-title">${game.name}</div>
      `;
      
      card.addEventListener('click', () => loadGame(game));
      
      emulatedList.appendChild(card);
    });
    
    console.log(`Rendered ${gamesToRender.length} emulated game cards`);
  }
  
  // ===== APPS PAGE =====
  function renderApps(appsToRender = apps) {
    const appList = document.getElementById('app-list');
    if (!appList) {
      console.warn('App list container not found');
      return;
    }
    
    if (typeof apps === 'undefined') {
      console.error('apps array not found');
      return;
    }
    
    appList.innerHTML = '';
    
    appsToRender.forEach(app => {
      const card = document.createElement('div');
      card.className = 'app-card';
      card.innerHTML = `
        <img src="${app.image}" alt="${app.name}" loading="lazy">
        <div class="app-card-title">${app.name}</div>
      `;
      
      card.addEventListener('click', () => {
        if (app.name === "YouTube") {
          window.location.href = app.url;
        } else {
          loadGame(app);
        }
      });
      
      appList.appendChild(card);
    });
    
    console.log(`Rendered ${appsToRender.length} app cards`);
  }
  
  // ===== LOAD GAME FUNCTION =====
  function loadGame(item) {
    const gameDisplay = document.getElementById('game-display');
    const gameIframe = document.getElementById('game-iframe');
    const allContent = document.querySelectorAll('.content');
    
    if (!gameDisplay || !gameIframe) {
      console.error('Game display elements not found');
      return;
    }
    
    // Hide all content sections
    allContent.forEach(content => content.style.display = 'none');
    
    // Show game display
    gameDisplay.style.display = 'block';
    gameIframe.src = item.url;
    
    console.log(`Loading: ${item.name}`);
  }
  
  // ===== SEARCH FUNCTIONALITY =====
  function setupSearch() {
    // Games search
    const searchInput = document.getElementById('searchInput');
    const searchBtn = document.getElementById('searchBtn');
    
    if (searchInput && searchBtn) {
      const handleSearch = () => {
        const query = searchInput.value.trim();
        const filtered = searchGamesData(query);
        renderGames(filtered);
      };
      
      searchBtn.addEventListener('click', handleSearch);
      searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') handleSearch();
      });
    }
    
    // Emulated games search
    const searchEmulatedInput = document.getElementById('searchEmulatedInput');
    const searchEmulatedBtn = document.getElementById('searchEmulatedBtn');
    
    if (searchEmulatedInput && searchEmulatedBtn) {
      const handleEmulatedSearch = () => {
        const query = searchEmulatedInput.value.trim();
        const filtered = searchEmulatedGamesData(query);
        renderEmulatedGames(filtered);
      };
      
      searchEmulatedBtn.addEventListener('click', handleEmulatedSearch);
      searchEmulatedInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') handleEmulatedSearch();
      });
    }
  }
  
  // ===== PAGE NAVIGATION =====
  function setupNavigation() {
    const sidebarLinks = document.querySelectorAll('.sidebar-link');
    const allContent = document.querySelectorAll('.content');
    
    sidebarLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        
        // Remove active class from all links
        sidebarLinks.forEach(l => l.classList.remove('active'));
        link.classList.add('active');
        
        // Hide all content
        allContent.forEach(content => content.style.display = 'none');
        
        // Show selected content
        const page = link.getAttribute('data-page');
        let contentId;
        
        switch(page) {
          case 'home':
            contentId = 'content-home';
            break;
          case 'games':
            contentId = 'content-gms';
            renderGames(); // Render games when page is shown
            break;
          case 'emulated':
            contentId = 'content-emulated';
            renderEmulatedGames(); // Render emulated games when page is shown
            break;
          case 'search':
            contentId = 'content-srch';
            break;
          case 'apps':
            contentId = 'content-aps';
            renderApps(); // Render apps when page is shown
            break;
          case 'settings':
            contentId = 'content-settings';
            break;
        }
        
        const content = document.getElementById(contentId);
        if (content) {
          content.style.display = 'block';
        }
      });
    });
    
    // Back to home buttons
    const backToHomeGame = document.getElementById('backToHomeGame');
    const backToHomeApps = document.getElementById('backToHomeApps');
    
    if (backToHomeGame) {
      backToHomeGame.addEventListener('click', () => {
        allContent.forEach(content => content.style.display = 'none');
        document.getElementById('content-home').style.display = 'block';
        document.getElementById('game-iframe').src = 'about:blank';
        
        // Reset active nav
        sidebarLinks.forEach(l => l.classList.remove('active'));
        document.getElementById('homeLink').classList.add('active');
      });
    }
    
    if (backToHomeApps) {
      backToHomeApps.addEventListener('click', () => {
        allContent.forEach(content => content.style.display = 'none');
        document.getElementById('content-home').style.display = 'block';
        
        // Reset active nav
        sidebarLinks.forEach(l => l.classList.remove('active'));
        document.getElementById('homeLink').classList.add('active');
      });
    }
  }
  
  // ===== FULLSCREEN BUTTON =====
  function setupFullscreen() {
    const fullscreenBtn = document.getElementById('fullscreenBtn');
    const gameIframe = document.getElementById('game-iframe');
    
    if (fullscreenBtn && gameIframe) {
      fullscreenBtn.addEventListener('click', () => {
        if (!document.fullscreenElement) {
          gameIframe.requestFullscreen().catch(err => {
            console.error('Fullscreen error:', err);
          });
        } else {
          document.exitFullscreen();
        }
      });
    }
  }
  
  // ===== INITIALIZE EVERYTHING =====
  console.log('Initializing render script...');
  
  renderCarousel();
  renderGames();
  setupSearch();
  setupNavigation();
  setupFullscreen();
  
  console.log('Render script initialization complete!');
});
