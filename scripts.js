// 70/30
// SEASONAL Tehesm sysnte
function getSeasonalTheme() {
  const now = new Date();
  const month = now.getMonth();
  const day = now.getDate();
  
  if ((month === 9 && day >= 20) || (month === 10 && day <= 2)) {
    return 'halloween';
  }
  
  if (month === 11 || (month === 0 && day <= 5)) {
    return 'christmas';
  }
  
  if (month > 1 && month < 5 || (month === 1 && day >= 20) || (month === 5 && day <= 20)) {
    return 'ocean';
  }
  
  if (month > 5 && month < 8 || (month === 5 && day >= 21) || (month === 8 && day <= 22)) {
    return 'light';
  }
  
  return 'original';
}

function shouldAutoApplySeasonalTheme() {
  const autoApply = localStorage.getItem('autoApplySeasonalThemes');
  return autoApply !== 'false';
}

//  ABOUT:BLANK CLOAKING 
(function() {
  const aboutBlankEnabled = localStorage.getItem('aboutBlank');
  const isInAboutBlank = window.self !== window.top;
  
  if (aboutBlankEnabled === 'enabled' && !isInAboutBlank) {
    const currentURL = window.location.href;
    const win = window.open('about:blank', '_blank');
    
    if (win) {
      win.document.open();
      win.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
          <title>New Tab</title>
          <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🌐</text></svg>">
        </head>
        <body style="margin:0;padding:0;overflow:hidden;">
          <iframe src="${currentURL}" style="position:fixed;top:0;left:0;width:100%;height:100%;border:none;"></iframe>
        </body>
        </html>
      `);
      win.document.close();
      window.location.replace('about:blank');
      window.close();
    }
  }
})();

//  TAB CLOAKING PRESETS =====
const presets = {
  google: { title: "Google", favicon: "https://www.google.com/favicon.ico" },
  classroom: { title: "Home", favicon: "https://ssl.gstatic.com/classroom/favicon.png" },
  bing: { title: "Bing", favicon: "https://bing.com/favicon.ico" },
  nearpod: { title: "Nearpod", favicon: "https://nearpod.com/favicon.ico" },
  powerschool: { title: "PowerSchool Sign In", favicon: "https://powerschool.com/favicon.ico" },
  edge: { title: "New Tab", favicon: "https://www.bing.com/favicon.ico" },
  chrome: { title: "New Tab", favicon: "https://www.google.com/favicon.ico" }
};

//  SNOW EFFECT =====
let snowEnabled = true;
let snowInterval = null;

function createSnowflake() {
  if (!snowEnabled) return;
  
  const snowflake = document.createElement('div');
  snowflake.classList.add('snowflake');
  const size = Math.random() * 4 + 2;
  snowflake.style.width = size + 'px';
  snowflake.style.height = size + 'px';
  snowflake.style.left = Math.random() * window.innerWidth + 'px';
  const fallDuration = Math.random() * 10 + 5;
  snowflake.style.animationDuration = fallDuration + 's';
  snowflake.style.animationDelay = Math.random() * 15 + 's';
  snowflake.style.opacity = (Math.random() * 0.5 + 0.3).toFixed(2);
  
  const snowContainer = document.getElementById('snow-container');
  if (snowContainer) {
    snowContainer.appendChild(snowflake);
    setTimeout(() => { 
      if (snowflake.parentNode) {
        snowflake.remove(); 
      }
    }, (fallDuration + 15) * 1000);
  }
}

function startSnow() {
  if (snowInterval) return;
  snowEnabled = true;
  snowInterval = setInterval(createSnowflake, 200);
}

function stopSnow() {
  snowEnabled = false;
  if (snowInterval) {
    clearInterval(snowInterval);
    snowInterval = null;
  }
  const snowContainer = document.getElementById('snow-container');
  if (snowContainer) snowContainer.innerHTML = '';
}

//  TAB CLOAKING =====
function applyTabCloaking(title, favicon) {
  if (title) {
    document.title = title;
    localStorage.setItem('TabCloak_Title', title);
  }
  if (favicon) {
    let link = document.querySelector("link[rel~='icon']");
    if (!link) {
      link = document.createElement('link');
      link.rel = 'icon';
      document.head.appendChild(link);
    }
    link.href = favicon;
    localStorage.setItem('TabCloak_Favicon', favicon);
  }
}

//  THEME SYSTEM WITH DATA ATTRIBUTES =====
function applyTheme(themeName) {
  // Define all theme colors
  const themes = {
    'original': {
      bg: '#1d2c54',
      sidebar: '#1e40af',
      nav: '#1e3a8a',
      text: '#ffffff',
      accent: '#60a5fa',
      border: '#3b82f6'
    },
    'dark': {
      bg: '#000000',
      sidebar: '#4f4f4f',
      nav: '#ababab',
      text: '#ffffff',
      accent: '#5c5c5c',
      border: '#8f8f8f'
    },
    'light': {
      bg: '#b0b0b0',
      sidebar: '#444444ff',
      nav: '#ffffff',
      text: '#0f172a',
      accent: '#000000ff',
      border: '#cbd5e1'
    },
    'midnight': {
      bg: '#0c0a1f',
      sidebar: '#1a1535',
      nav: '#1a1535',
      text: '#e0d8ff',
      accent: '#a78bfa',
      border: '#4c1d95'
    },
    'ocean': {
      bg: '#0c4a6e',
      sidebar: '#075985',
      nav: '#0e7490',
      text: '#e0f2fe',
      accent: '#22d3ee',
      border: '#0891b2'
    },
    'sunset': {
      bg: '#7c2d12',
      sidebar: '#9a3412',
      nav: '#c2410c',
      text: '#fed7aa',
      accent: '#fb923c',
      border: '#ea580c'
    },
    'forest': {
      bg: '#14532d',
      sidebar: '#166534',
      nav: '#15803d',
      text: '#dcfce7',
      accent: '#4ade80',
      border: '#22c55e'
    },
    'purple': {
      bg: '#581c87',
      sidebar: '#6b21a8',
      nav: '#7e22ce',
      text: '#f3e8ff',
      accent: '#c084fc',
      border: '#a855f7'
    },
    'cyberpunk': {
      bg: '#1a0b2e',
      sidebar: '#2d1b4e',
      nav: '#16213e',
      text: '#00ff9f',
      accent: '#ff006e',
      border: '#7b2cbf'
    },
    'matrix': {
      bg: '#0d0d0d',
      sidebar: '#1a1a1a',
      nav: '#1a1a1a',
      text: '#00ff41',
      accent: '#00ff41',
      border: '#003b00'
    },
    'neon': {
      bg: '#120458',
      sidebar: '#2d1b69',
      nav: '#1a0b3a',
      text: '#ffffff',
      accent: '#ff10f0',
      border: '#39ff14'
    },
    'fire': {
      bg: '#7f1d1d',
      sidebar: '#991b1b',
      nav: '#b91c1c',
      text: '#fef2f2',
      accent: '#fbbf24',
      border: '#f59e0b'
    },
    'ice': {
      bg: '#0c4a6e',
      sidebar: '#075985',
      nav: '#0369a1',
      text: '#e0f2fe',
      accent: '#7dd3fc',
      border: '#0ea5e9'
    },
    'retro': {
      bg: '#422006',
      sidebar: '#713f12',
      nav: '#854d0e',
      text: '#fef3c7',
      accent: '#fbbf24',
      border: '#f59e0b'
    },
    'Anzo': {
      bg: '#160000fa',
      sidebar: '#ffffffff',
      nav: '#ababab',
      text: '#ffffff',
      accent: '#000000',
      border: '#ffffffff'
    },
    'halloween': {
      bg: '#1a0b2e',
      sidebar: '#2d1b4e',
      nav: '#3d2652',
      text: '#f9a8d4',
      accent: '#ff6b35',
      border: '#ff006e'
    },
    'christmas': {
      bg: '#7f1d1d',
      sidebar: '#991b1b',
      nav: '#15803d',
      text: '#fef2f2',
      accent: '#4ade80',
      border: '#22c55e'
    }
  };


  const themeColors = themes[themeName] || themes['original'];
  

  document.documentElement.setAttribute('data-theme', themeName);
  

  document.body.style.backgroundColor = themeColors.bg;
  document.body.style.color = themeColors.text;
  

  const sidebar = document.querySelector('.sidebar');
  if (sidebar) {
    sidebar.style.backgroundColor = themeColors.sidebar;
  }
  

  const contentSections = document.querySelectorAll('.content');
  contentSections.forEach(section => {
    section.style.backgroundColor = themeColors.bg;
    section.style.color = themeColors.text;
  });
  

  const navElements = document.querySelectorAll('.sidebar-link');
  navElements.forEach(nav => {
    nav.style.color = themeColors.text;
  });
  

  const root = document.documentElement;
  root.style.setProperty('--bg-color', themeColors.bg);
  root.style.setProperty('--sidebar-color', themeColors.sidebar);
  root.style.setProperty('--nav-color', themeColors.nav);
  root.style.setProperty('--text-color', themeColors.text);
  root.style.setProperty('--accent-color', themeColors.accent);
  root.style.setProperty('--border-color', themeColors.border);
  

  setTimeout(() => {
    const metaThemeColor = document.querySelector('meta[name="theme-color"]');
    if (metaThemeColor) {
      metaThemeColor.setAttribute('content', themeColors.bg);
    }
  }, 50);
  
  // Save to localStorage
  localStorage.setItem('selectedTheme', themeName);
  
  console.log('Theme applied:', themeName);
}

//  SETTINGS TABS SYSTEM =====
function setupSettingsTabs() {
  const tabBtns = document.querySelectorAll('.settings-tab-btn');
  const tabContents = document.querySelectorAll('.settings-tab-content');
  
  tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const targetTab = btn.dataset.tab;
      
      // Remove active class from all buttons and contents
      tabBtns.forEach(b => b.classList.remove('active'));
      tabContents.forEach(c => c.classList.remove('active'));
      
      // Add active class to clicked button and corresponding content
      btn.classList.add('active');
      const targetContent = document.getElementById(`tab-${targetTab}`);
      if (targetContent) {
        targetContent.classList.add('active');
      }
      
      // Log if debug mode is enabled
      if (localStorage.getItem('debugMode') === 'enabled') {
        console.log('Settings tab switched to:', targetTab);
      }
    });
  });
}

//  ANTI TAB CLOSE FUNCTIONALITY =====
function setupAntiTabClose() {
  const antiTabCloseToggle = document.getElementById('antiTabCloseToggle');
  
  if (antiTabCloseToggle) {
    // Load saved setting
    const savedAntiClose = localStorage.getItem('antiTabClose');
    antiTabCloseToggle.checked = savedAntiClose === 'enabled';
    
    // Apply setting if enabled
    if (savedAntiClose === 'enabled') {
      enableAntiTabClose();
    }
    
    // Listen for changes
    antiTabCloseToggle.addEventListener('change', (e) => {
      if (e.target.checked) {
        localStorage.setItem('antiTabClose', 'enabled');
        enableAntiTabClose();
        if (localStorage.getItem('debugMode') === 'enabled') {
          console.log('Anti Tab Close enabled');
        }
      } else {
        localStorage.removeItem('antiTabClose');
        disableAntiTabClose();
        if (localStorage.getItem('debugMode') === 'enabled') {
          console.log('Anti Tab Close disabled');
        }
      }
    });
  }
}

function enableAntiTabClose() {
  window.addEventListener('beforeunload', confirmClose);
}

function disableAntiTabClose() {
  window.removeEventListener('beforeunload', confirmClose);
}

function confirmClose(e) {
  e.preventDefault();
  e.returnValue = '';
  return '';
}

//  DEBUG MODE FUNCTIONALITY =====
function setupDebugMode() {
  const debugToggle = document.getElementById('debugModeToggle');
  
  if (debugToggle) {
    const savedDebug = localStorage.getItem('debugMode');
    debugToggle.checked = savedDebug === 'enabled';
    
    // Log initial state if debug is enabled
    if (savedDebug === 'enabled') {
      console.log('=== Debug Mode Active ===');
      console.log('Current Settings:', {
        theme: localStorage.getItem('selectedTheme'),
        snowEffect: localStorage.getItem('snowEffect'),
        tabTitle: localStorage.getItem('TabCloak_Title'),
        antiTabClose: localStorage.getItem('antiTabClose'),
        aboutBlank: localStorage.getItem('aboutBlank'),
        hotkey: localStorage.getItem('hotkey'),
        redirectURL: localStorage.getItem('redirectURL')
      });
    }
    
    debugToggle.addEventListener('change', (e) => {
      if (e.target.checked) {
        localStorage.setItem('debugMode', 'enabled');
        console.log('=== Debug Mode Enabled ===');
        console.log('Current Settings:', {
          theme: localStorage.getItem('selectedTheme'),
          snowEffect: localStorage.getItem('snowEffect'),
          tabTitle: localStorage.getItem('TabCloak_Title'),
          antiTabClose: localStorage.getItem('antiTabClose'),
          aboutBlank: localStorage.getItem('aboutBlank'),
          hotkey: localStorage.getItem('hotkey'),
          redirectURL: localStorage.getItem('redirectURL')
        });
        console.log('Browser Info:', {
          userAgent: navigator.userAgent,
          platform: navigator.platform,
          language: navigator.language,
          cookiesEnabled: navigator.cookieEnabled
        });
      } else {
        console.log('Debug mode disabled');
        localStorage.removeItem('debugMode');
      }
    });
  }
}

//  CLEAR CACHE FUNCTIONALITY =====
function setupClearCache() {
  const clearCacheBtn = document.getElementById('clearCacheBtn');
  
  if (clearCacheBtn) {
    clearCacheBtn.addEventListener('click', () => {
      if (confirm('This will clear all your settings and reload the page. Continue?')) {
        if (localStorage.getItem('debugMode') === 'enabled') {
          console.log('Clearing cache...');
          console.log('Items to be removed:', Object.keys(localStorage));
        }
        
        // Clear all localStorage except essential items
        const essentialKeys = ['games', 'apps', 'emulatedGames', 'websites'];
        Object.keys(localStorage).forEach(key => {
          if (!essentialKeys.includes(key)) {
            localStorage.removeItem(key);
          }
        });
        
        console.log('Cache cleared, reloading...');
        location.reload();
      }
    });
  }
}

//  SYSTEM INFORMATION DISPLAY =====
function displaySystemInfo() {
  const browserInfo = document.getElementById('browserInfo');
  const platformInfo = document.getElementById('platformInfo');
  const screenInfo = document.getElementById('screenInfo');
  const storageInfo = document.getElementById('storageInfo');
  
  if (browserInfo) {
    const ua = navigator.userAgent;
    let browserName = 'Unknown';
    
    if (ua.includes('Firefox')) browserName = 'Firefox';
    else if (ua.includes('Chrome') && !ua.includes('Edg')) browserName = 'Chrome';
    else if (ua.includes('Safari') && !ua.includes('Chrome')) browserName = 'Safari';
    else if (ua.includes('Edg')) browserName = 'Edge';
    else if (ua.includes('Opera') || ua.includes('OPR')) browserName = 'Opera';
    
    browserInfo.textContent = browserName;
  }
  
  if (platformInfo) {
    platformInfo.textContent = navigator.platform || 'Unknown';
  }
  
  if (screenInfo) {
    screenInfo.textContent = `${window.screen.width}x${window.screen.height}`;
  }
  
  if (storageInfo) {
    try {
      let totalSize = 0;
      for (let key in localStorage) {
        if (localStorage.hasOwnProperty(key)) {
          totalSize += localStorage[key].length + key.length;
        }
      }
      const sizeInKB = (totalSize / 1024).toFixed(2);
      storageInfo.textContent = `${sizeInKB} KB`;
    } catch (e) {
      storageInfo.textContent = 'Unable to calculate';
    }
  }
}

//  LOAD SETTINGS =====
function loadSettings() {
  let themeToUse = 'original';
  const savedTheme = localStorage.getItem('selectedTheme');
  
  if (!savedTheme && shouldAutoApplySeasonalTheme()) {
    themeToUse = getSeasonalTheme();
  } else if (savedTheme) {
    themeToUse = savedTheme;
  }

  const savedTitle = localStorage.getItem('TabCloak_Title');
  const savedFavicon = localStorage.getItem('TabCloak_Favicon');
  const savedSnow = localStorage.getItem('snowEffect');
  const savedHotkey = localStorage.getItem('hotkey') || '`';
  const savedRedirect = localStorage.getItem('redirectURL') || 'https://google.com';
  const savedAboutBlank = localStorage.getItem('aboutBlank');
  const savedAntiClose = localStorage.getItem('antiTabClose');

  if (savedTitle) {
    document.title = savedTitle;
    const titleInput = document.getElementById('customTitle');
    if (titleInput) titleInput.value = savedTitle;
  }

  if (savedFavicon) {
    let link = document.querySelector("link[rel~='icon']");
    if (!link) {
      link = document.createElement('link');
      link.rel = 'icon';
      document.head.appendChild(link);
    }
    link.href = savedFavicon;
    const faviconInput = document.getElementById('customFavicon');
    if (faviconInput) faviconInput.value = savedFavicon;
  }

  if (savedSnow === 'disabled') {
    snowEnabled = false;
    const snowToggle = document.getElementById('snowToggle');
    if (snowToggle) snowToggle.checked = false;
    stopSnow();
  } else {
    startSnow();
  }

  const hotkeyInput = document.getElementById('hotkey-input');
  const redirectInput = document.getElementById('redirect-url-input');
  if (hotkeyInput) hotkeyInput.value = savedHotkey;
  if (redirectInput) redirectInput.value = savedRedirect;

  const aboutBlankToggle = document.getElementById('aboutBlankToggle');
  if (aboutBlankToggle) {
    aboutBlankToggle.checked = savedAboutBlank === 'enabled';
  }

  // Load anti-tab-close setting
  if (savedAntiClose === 'enabled') {
    enableAntiTabClose();
  }

  // Apply theme
  applyTheme(themeToUse);
  
  // Log settings if debug mode is enabled
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Settings loaded:', {
      theme: themeToUse,
      snow: savedSnow !== 'disabled',
      antiTabClose: savedAntiClose === 'enabled'
    });
  }
}

//  PANIC BUTTON =====
function setupPanicButton() {
  const savedHotkey = localStorage.getItem('hotkey') || '`';
  const savedRedirect = localStorage.getItem('redirectURL') || 'https://google.com';
  
  document.addEventListener('keydown', (e) => {
    if (e.key === savedHotkey) {
      if (localStorage.getItem('debugMode') === 'enabled') {
        console.log('Panic button triggered! Redirecting to:', savedRedirect);
      }
      window.location.href = savedRedirect;
    }
  });
  
  const changeHotkeyBtn = document.getElementById('change-hotkey-btn');
  const hotkeyInput = document.getElementById('hotkey-input');
  
  if (changeHotkeyBtn && hotkeyInput) {
    changeHotkeyBtn.addEventListener('click', () => {
      hotkeyInput.focus();
      hotkeyInput.placeholder = 'Press a key...';
    });
  }
  
  if (hotkeyInput) {
    hotkeyInput.addEventListener('keydown', (e) => {
      e.preventDefault();
      if (e.key.length === 1 || e.key === 'Escape' || /^F\d{1,2}$/.test(e.key)) {
        hotkeyInput.value = e.key;
        localStorage.setItem('hotkey', e.key);
        hotkeyInput.blur();
        if (localStorage.getItem('debugMode') === 'enabled') {
          console.log('Panic hotkey updated to:', e.key);
        }
      }
    });
  }
  
  const changeURLBtn = document.getElementById('change-URL-btn');
  const redirectInput = document.getElementById('redirect-url-input');
  
  if (changeURLBtn && redirectInput) {
    changeURLBtn.addEventListener('click', () => {
      const url = redirectInput.value.trim();
      if (url) {
        localStorage.setItem('redirectURL', url);
        alert('Redirect URL updated!');
        if (localStorage.getItem('debugMode') === 'enabled') {
          console.log('Redirect URL updated to:', url);
        }
      }
    });
  }
}

//  UTILITY FUNCTIONS =====
function debounce(func, delay) {
  delay = delay || 300;
  let timeout;
  return function() {
    const context = this;
    const args = arguments;
    clearTimeout(timeout);
    timeout = setTimeout(() => func.apply(context, args), delay);
  };
}

function hideAll() {
  document.querySelectorAll('.content').forEach(c => c.style.display = 'none');
  document.querySelectorAll('.sidebar-link').forEach(link => link.classList.remove('active'));
  const infoButtons = document.querySelector('.homepage-info-buttons');
  if (infoButtons) infoButtons.style.display = 'none';
}

//  NAVIGATION FUNCTIONS =====
function showHome() {
  hideAll();
  const homeContent = document.getElementById('content-home');
  if (homeContent) homeContent.style.display = 'block';
  const homeLink = document.getElementById('homeLink');
  if (homeLink) homeLink.classList.add('active');
  const infoButtons = document.querySelector('.homepage-info-buttons');
  if (infoButtons) infoButtons.style.display = 'flex';
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Navigated to: Home');
  }
}

function showGames() {
  hideAll();
  const gamesContent = document.getElementById('content-gms');
  if (gamesContent) gamesContent.style.display = 'block';
  const gameLink = document.getElementById('gameLink');
  if (gameLink) gameLink.classList.add('active');
  
  if (!document.querySelector('.game-filters') && window.GameStats) {
    const searchContainer = document.querySelector('.search-container');
    if (searchContainer) {
      const filtersHTML = window.GameStats.createFilterButtons();
      searchContainer.insertAdjacentHTML('afterend', filtersHTML);
    }
  }
  
  if (typeof games !== 'undefined' && Array.isArray(games)) {
    const activeFilter = document.querySelector('.filter-btn.active');
    if (activeFilter) {
      const filter = activeFilter.dataset.filter;
      window.filterGames(filter);
    } else {
      renderGames(games);
    }
  }
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Navigated to: Games');
  }
}

function showSearch() {
  hideAll();
  const searchContent = document.getElementById('content-srch');
  if (searchContent) searchContent.style.display = 'block';
  const searchLink = document.getElementById('searchLink');
  if (searchLink) searchLink.classList.add('active');
  
  setTimeout(() => {
    const proxyInput = document.getElementById('proxyUrlInput');
    if (proxyInput) proxyInput.focus();
  }, 100);
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Navigated to: Search');
  }
}

function showApps() {
  hideAll();
  const appsContent = document.getElementById('content-aps');
  if (appsContent) appsContent.style.display = 'block';
  const appsLink = document.getElementById('appsLink');
  if (appsLink) appsLink.classList.add('active');
  
  if (typeof apps !== 'undefined' && Array.isArray(apps)) {
    renderApps(apps);
  }
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Navigated to: Apps');
  }
}

function showWebsites() {
  hideAll();
  const websitesContent = document.getElementById('content-websites');
  if (websitesContent) websitesContent.style.display = 'block';
  const websitesLink = document.getElementById('websitesLink');
  if (websitesLink) websitesLink.classList.add('active');
  
  if (typeof websites !== 'undefined' && Array.isArray(websites)) {
    renderWebsites(websites);
  }
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Navigated to: Websites');
  }
}

function showAbout() {
  hideAll();
  const aboutContent = document.getElementById('content-about');
  if (aboutContent) aboutContent.style.display = 'block';
  const aboutLink = document.getElementById('aboutLink');
  if (aboutLink) aboutLink.classList.add('active');
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Navigated to: About');
  }
}

function showSettings() {
  hideAll();
  const settingsContent = document.getElementById('content-settings');
  if (settingsContent) settingsContent.style.display = 'block';
  const settingsLink = document.getElementById('settingsLink');
  if (settingsLink) settingsLink.classList.add('active');
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Navigated to: Settings');
  }
}

function showEmulated() {
  hideAll();
  const emulatedContent = document.getElementById('content-emulated');
  if (emulatedContent) emulatedContent.style.display = 'block';
  const emulatedLink = document.getElementById('emulatedLink');
  if (emulatedLink) emulatedLink.classList.add('active');
  
  if (typeof emulatedGames !== 'undefined' && Array.isArray(emulatedGames)) {
    renderEmulatedGames(emulatedGames);
  }
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Navigated to: Emulated Games');
  }
}

//  GAME LOADING AND RENDERING =====
function loadGame(urlOrGame) {
  let url;
  let gameData = null;
  
  if (typeof urlOrGame === 'string') {
    url = urlOrGame;
    // Try to find the game in the games array by URL
    if (typeof games !== 'undefined') {
      gameData = games.find(g => g.file === url || g.url === url);
    }
  } else if (urlOrGame && typeof urlOrGame === 'object') {
    url = urlOrGame.url || urlOrGame.file;
    gameData = urlOrGame;
  } else {
    console.error('Invalid argument provided to loadGame:', urlOrGame);
    alert('Error: Invalid game data.');
    return;
  }
  
  if (!url) {
    console.error('No URL provided');
    alert('Error: Game URL is missing.');
    return;
  }
  
  try {
    const isYouTube = url.includes('/others/assets/apps/YouTube.html') || url.includes('youtu.be');
    
    if (isYouTube) {
      window.open(url, '_blank');
      return;
    }
    
    // Track this game as recently played
    if (gameData && typeof RecentlyPlayed !== 'undefined') {
      RecentlyPlayed.add({
        id: gameData.id || url,
        title: gameData.title || gameData.name || 'Unknown Game',
        img: gameData.img || gameData.image || 'others/assets/relic.webp',
        file: url
      });
    }
    
    hideAll();
    const gameDisplay = document.getElementById('game-display');
    const gameIframe = document.getElementById('game-iframe');
    
    if (!gameDisplay || !gameIframe) {
      console.error('Game display elements not found');
      alert('Error: Unable to load game.');
      return;
    }
    
    if (window.GameStats) {
      window.GameStats.stopTracking();
    }
    
    gameIframe.src = '';
    gameIframe.src = url;
    gameDisplay.style.display = 'block';
    
    gameIframe.onload = function() {
      if (window.GameStats) {
        window.GameStats.startTracking(url);
      }
    };
    
    gameIframe.onerror = function() {
      console.error('Failed to load game:', url);
      alert('Error loading game.');
    };
    
    if (localStorage.getItem('debugMode') === 'enabled') {
      console.log('Game loaded:', url);
      if (gameData) {
        console.log('Game data:', gameData);
      }
    }
  } catch (error) {
    console.error('Error in loadGame:', error);
    alert('An error occurred while loading the game.');
  }
}

function renderGames(gamesToRender) {
  const gameList = document.getElementById('game-list');
  if (!gameList) return;
  
  gameList.innerHTML = '';
  
  if (!gamesToRender || gamesToRender.length === 0) {
    gameList.innerHTML = '<p style="padding: 20px; text-align: center;">No games found.</p>';
    return;
  }
  
  gamesToRender.forEach(game => {
    if (!game || !game.name || !game.url) return;
    
    const isFavorited = window.GameStats ? window.GameStats.isFavorite(game.url) : false;
    
    const card = document.createElement('div');
    card.className = 'game-card';
    card.tabIndex = 0;
    card.innerHTML = (window.GameStats ? window.GameStats.createFavoriteButton(game.url, isFavorited) : '') + '<img src="' + (game.image || 'https://via.placeholder.com/250x250?text=Game') + '" alt="' + game.name + '" loading="lazy" /><h3>' + game.name + '</h3>';
    
    card.onclick = () => loadGame(game.url);
    card.onkeypress = (e) => { if (e.key === 'Enter') loadGame(game.url); };
    
    gameList.appendChild(card);
  });
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Rendered games:', gamesToRender.length);
  }
}

function renderEmulatedGames(gamesToRender) {
  const emulatedList = document.getElementById('emulated-list');
  if (!emulatedList) return;
  
  emulatedList.innerHTML = '';
  
  if (!gamesToRender || gamesToRender.length === 0) {
    emulatedList.innerHTML = '<p style="padding: 20px; text-align: center;">No emulated games found.</p>';
    return;
  }
  
  gamesToRender.forEach(game => {
    if (!game || !game.name || !game.url) return;
    
    const card = document.createElement('div');
    card.className = 'game-card';
    card.tabIndex = 0;
    card.innerHTML = '<img src="' + (game.image || 'https://via.placeholder.com/250x250?text=Game') + '" alt="' + game.name + '" loading="lazy" /><h3>' + game.name + '</h3>';
    
    card.onclick = () => loadGame(game.url);
    card.onkeypress = (e) => { if (e.key === 'Enter') loadGame(game.url); };
    
    emulatedList.appendChild(card);
  });
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Rendered emulated games:', gamesToRender.length);
  }
}

function renderApps(appsToRender) {
  const appList = document.getElementById('app-list');
  if (!appList) return;
  
  appList.innerHTML = '';
  
  if (!appsToRender || appsToRender.length === 0) {
    appList.innerHTML = '<p>No apps found.</p>';
    return;
  }
  
  appsToRender.forEach(app => {
    if (!app || !app.name || !app.url) return;
    
    const card = document.createElement('div');
    card.className = 'app-card';
    card.innerHTML = '<img src="' + (app.image || 'https://via.placeholder.com/250x250?text=App') + '" alt="' + app.name + '" loading="lazy" /><h3>' + app.name + '</h3>';
    card.onclick = () => loadGame(app.url);
    appList.appendChild(card);
  });
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Rendered apps:', appsToRender.length);
  }
}

function renderWebsites(websitesToRender) {
  const websitesList = document.getElementById('websites-list');
  if (!websitesList) return;
  
  websitesList.innerHTML = '';
  
  if (!websitesToRender || websitesToRender.length === 0) {
    websitesList.innerHTML = '<p>No websites found.</p>';
    return;
  }
  
  const list = document.createElement('ul');
  list.style.cssText = 'list-style: none; padding: 20px; max-width: 800px; margin: 0 auto;';
  
  websitesToRender.forEach(website => {
    if (!website || !website.name || !website.url) return;
    
    const listItem = document.createElement('li');
    listItem.style.cssText = 'padding: 15px; margin-bottom: 10px; background: var(--nav-color); border: 1px solid var(--border-color); border-radius: 8px; transition: all 0.3s ease;';
    
    listItem.innerHTML = '<a href="' + website.url + '" target="_blank" style="color: var(--accent-color); text-decoration: none; font-size: 18px; display: flex; align-items: center; gap: 10px;"><span>🔗</span><div><div style="font-weight: 600;">' + website.name + '</div><div style="font-size: 14px; color: var(--text-color); opacity: 0.7; margin-top: 4px;">' + website.url + '</div></div></a>';
    
    listItem.addEventListener('mouseenter', function() {
      this.style.background = 'var(--hover-bg)';
      this.style.borderColor = 'var(--accent-color)';
      this.style.transform = 'translateX(5px)';
    });
    
    listItem.addEventListener('mouseleave', function() {
      this.style.background = 'var(--nav-color)';
      this.style.borderColor = 'var(--border-color)';
      this.style.transform = 'translateX(0)';
    });
    
    list.appendChild(listItem);
  });
  
  websitesList.appendChild(list);
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Rendered websites:', websitesToRender.length);
  }
}

//  SEARCH FUNCTIONS =====
function searchGames() {
  const searchInput = document.getElementById('searchInput');
  if (!searchInput) return;
  
  const query = searchInput.value.toLowerCase().trim();
  
  if (typeof games === 'undefined' || !Array.isArray(games)) {
    console.error('games array not found');
    return;
  }
  
  if (!query) {
    renderGames(games);
    return;
  }
  
  const filtered = games.filter(game => game && game.name && game.name.toLowerCase().includes(query));
  renderGames(filtered);
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Game search:', query, 'Results:', filtered.length);
  }
}

function searchEmulatedGames() {
  const searchInput = document.getElementById('searchEmulatedInput');
  if (!searchInput) return;
  
  const query = searchInput.value.toLowerCase().trim();
  
  if (typeof emulatedGames === 'undefined' || !Array.isArray(emulatedGames)) {
    console.error('emulatedGames array not found');
    return;
  }
  
  if (!query) {
    renderEmulatedGames(emulatedGames);
    return;
  }
  
  const filtered = emulatedGames.filter(game => game && game.name && game.name.toLowerCase().includes(query));
  renderEmulatedGames(filtered);
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Emulated game search:', query, 'Results:', filtered.length);
  }
}

function searchWebsites() {
  const searchInput = document.getElementById('websitesSearchInput');
  if (!searchInput) return;
  
  const query = searchInput.value.toLowerCase().trim();
  
  if (typeof websites === 'undefined' || !Array.isArray(websites)) {
    console.error('websites array not found');
    return;
  }
  
  if (!query) {
    renderWebsites(websites);
    return;
  }
  
  const filtered = websites.filter(site => site && site.name && site.name.toLowerCase().includes(query));
  renderWebsites(filtered);
  
  if (localStorage.getItem('debugMode') === 'enabled') {
    console.log('Website search:', query, 'Results:', filtered.length);
  }
}

function toggleFullscreen() {
  const gameIframe = document.getElementById('game-iframe');
  if (!gameIframe) return;
  
  try {
    if (!document.fullscreenElement) {
      gameIframe.requestFullscreen().catch(err => {
        console.error('Fullscreen error:', err);
        alert('Fullscreen not available. Click on the game first.');
      });
    } else {
      document.exitFullscreen();
    }
  } catch (error) {
    console.error('Fullscreen error:', error);
  }
}

function refreshGame() {
  const gameIframe = document.getElementById('game-iframe');
  if (!gameIframe) return;
  
  try {
    const currentSrc = gameIframe.src;
    gameIframe.src = '';
    setTimeout(() => {
      gameIframe.src = currentSrc;
      
      if (localStorage.getItem('debugMode') === 'enabled') {
        console.log('Game refreshed:', currentSrc);
      }
    }, 100);
  } catch (error) {
    console.error('Refresh error:', error);
  }
}
//  INITIALIZATION =====
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeApp);
} else {
  initializeApp();
}

function initializeApp() {
  try {
    if (localStorage.getItem('debugMode') === 'enabled') {
      console.log('=== Initializing Relic Ultimate ===');
      console.log('Document ready state:', document.readyState);
    }
    
    loadSettings();
    showHome();
    setupPanicButton();
    setupSettingsTabs();
    setupAntiTabClose();
    setupDebugMode();
    setupClearCache();
    displaySystemInfo();

    // Theme Select Handler
    const themeSelect = document.getElementById('themeSelect');
    if (themeSelect) {
      const savedTheme = localStorage.getItem('selectedTheme');
      if (savedTheme) {
        themeSelect.value = savedTheme;
      } else if (shouldAutoApplySeasonalTheme()) {
        themeSelect.value = getSeasonalTheme();
      } else {
        themeSelect.value = 'original';
      }
      
      themeSelect.addEventListener('change', (e) => {
        const theme = e.target.value;
        applyTheme(theme);
      });
    }

    // Modal Handlers
    const creditsBtn = document.getElementById('creditsBtn');
    const updateLogBtn = document.getElementById('updateLogBtn');
    const creditsModal = document.getElementById('creditsModal');
    const updateLogModal = document.getElementById('updateLogModal');

    if (creditsBtn && creditsModal) {
      creditsBtn.addEventListener('click', () => {
        creditsModal.style.display = 'block';
      });
    }

    if (updateLogBtn && updateLogModal) {
      updateLogBtn.addEventListener('click', () => {
        updateLogModal.style.display = 'block';
      });
    }

    document.querySelectorAll('.info-close').forEach(closeBtn => {
      closeBtn.addEventListener('click', function() {
        const modalId = this.getAttribute('data-modal');
        const modalElement = document.getElementById(modalId);
        if (modalElement) {
          modalElement.style.display = 'none';
        }
      });
    });

    window.onclick = (e) => {
      if (e.target.classList.contains('info-modal')) {
        e.target.style.display = 'none';
      }
    };

    // Tab Cloaking Handlers
    const applyBtn = document.getElementById('applyBtn');
    if (applyBtn) {
      applyBtn.addEventListener('click', () => {
        const titleInput = document.getElementById('customTitle');
        const faviconInput = document.getElementById('customFavicon');
        const title = titleInput ? titleInput.value.trim() : '';
        const favicon = faviconInput ? faviconInput.value.trim() : '';
        applyTabCloaking(title, favicon);
        alert('Tab cloaking applied!');
      });
    }

    const resetBtn = document.getElementById('resetBtn');
    if (resetBtn) {
      resetBtn.addEventListener('click', () => {
        localStorage.removeItem('TabCloak_Title');
        localStorage.removeItem('TabCloak_Favicon');
        document.title = 'Relic';
        const link = document.querySelector("link[rel~='icon']");
        if (link) link.href = '';
        const titleInput = document.getElementById('customTitle');
        const faviconInput = document.getElementById('customFavicon');
        if (titleInput) titleInput.value = '';
        if (faviconInput) faviconInput.value = '';
        const presetSelect = document.getElementById('presetSelect');
        if (presetSelect) presetSelect.value = '';
        alert('Tab cloaking reset!');
      });
    }

    const presetSelect = document.getElementById('presetSelect');
    if (presetSelect) {
      presetSelect.addEventListener('change', (e) => {
        const selected = presets[e.target.value];
        if (selected) {
          const titleInput = document.getElementById('customTitle');
          const faviconInput = document.getElementById('customFavicon');
          if (titleInput) titleInput.value = selected.title;
          if (faviconInput) faviconInput.value = selected.favicon;
          applyTabCloaking(selected.title, selected.favicon);
        }
      });
    }

    // Snow Toggle
    const snowToggle = document.getElementById('snowToggle');
    if (snowToggle) {
      snowToggle.addEventListener('change', (e) => {
        if (e.target.checked) {
          localStorage.setItem('snowEffect', 'enabled');
          startSnow();
        } else {
          localStorage.setItem('snowEffect', 'disabled');
          stopSnow();
        }
      });
    }

    // About Blank Toggle
    const aboutBlankToggle = document.getElementById('aboutBlankToggle');
    if (aboutBlankToggle) {
      aboutBlankToggle.addEventListener('change', (e) => {
        if (e.target.checked) {
          localStorage.setItem('aboutBlank', 'enabled');
        } else {
          localStorage.removeItem('aboutBlank');
        }
      });
    }

    // Navigation Links
    const homeLink = document.getElementById('homeLink');
    const gameLink = document.getElementById('gameLink');
    const emulatedLink = document.getElementById('emulatedLink');
    const appsLink = document.getElementById('appsLink');
    const searchLink = document.getElementById('searchLink');
    const settingsLink = document.getElementById('settingsLink');

    if (homeLink) homeLink.addEventListener('click', (e) => { e.preventDefault(); showHome(); });
    if (gameLink) gameLink.addEventListener('click', (e) => { e.preventDefault(); showGames(); });
    if (emulatedLink) emulatedLink.addEventListener('click', (e) => { e.preventDefault(); showEmulated(); });
    if (appsLink) appsLink.addEventListener('click', (e) => { e.preventDefault(); showApps(); });
    if (searchLink) searchLink.addEventListener('click', (e) => { e.preventDefault(); showSearch(); });
    if (settingsLink) settingsLink.addEventListener('click', (e) => { e.preventDefault(); showSettings(); });

    // Back to Home Buttons
    const backToHomeGame = document.getElementById('backToHomeGame');
    const backToHomeApps = document.getElementById('backToHomeApps');
    
    if (backToHomeGame) {
      backToHomeGame.addEventListener('click', () => {
        if (window.GameStats) {
          window.GameStats.stopTracking();
        }
        showHome();
      });
    }
    
    if (backToHomeApps) {
      backToHomeApps.addEventListener('click', () => showHome());
    }

    // Search Handlers for Games
    const searchBtn = document.getElementById('searchBtn');
    const searchInput = document.getElementById('searchInput');
    
    if (searchBtn) {
      searchBtn.addEventListener('click', searchGames);
    }
    
    if (searchInput) {
      searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') searchGames();
      });
      searchInput.addEventListener('input', debounce(searchGames, 300));
    }

    // Search Handlers for Emulated Games
    const searchEmulatedBtn = document.getElementById('searchEmulatedBtn');
    const searchEmulatedInput = document.getElementById('searchEmulatedInput');
    
    if (searchEmulatedBtn) {
      searchEmulatedBtn.addEventListener('click', searchEmulatedGames);
    }
    
    if (searchEmulatedInput) {
      searchEmulatedInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') searchEmulatedGames();
      });
      searchEmulatedInput.addEventListener('input', debounce(searchEmulatedGames, 300));
    }

    // Fullscreen Button
    const fullscreenBtn = document.getElementById('fullscreenBtn');
    if (fullscreenBtn) {
      fullscreenBtn.addEventListener('click', toggleFullscreen);
    }
    
    if (localStorage.getItem('debugMode') === 'enabled') {
      console.log('=== Initialization Complete ===');
      console.log('All event listeners attached successfully');
    }
  } catch (error) {
    console.error('Critical error during initialization:', error);
    alert('An error occurred during initialization. Check console for errors pls.');
  }
}
