(function() {
  const themeSelect = document.getElementById('themeSelect');
  

  function loadSavedTheme() {
    const savedTheme = localStorage.getItem('selectedTheme') || 'original';
    console.log('Loading saved theme:', savedTheme);
    applyTheme(savedTheme);
    
    
    if (themeSelect) {
      themeSelect.value = savedTheme;
    }
  }

  
  function applyTheme(themeName) {
    const root = document.documentElement;
    
    // Remove any existing theme
    root.removeAttribute('data-theme');
    
    // Apply new theme that is chosen
    if (themeName && themeName !== 'original') {
      root.setAttribute('data-theme', themeName);
      console.log('Applied theme:', themeName);
    } else {
      console.log('Applied original theme');
    }
    
    // Save to localStorage
    localStorage.setItem('selectedTheme', themeName);
    
    // Trigger sidebar color update if available
    setTimeout(() => {
      if (window.updateSidebarTheme) {
        window.updateSidebarTheme();
      }
    }, 100);
  }

  // Listen for theme changes
  if (themeSelect) {
    themeSelect.addEventListener('change', function(e) {
      const selectedTheme = e.target.value;
      console.log('Theme changed to:', selectedTheme);
      applyTheme(selectedTheme);
    });
  }

  // Load theme when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', loadSavedTheme);
  } else {
    loadSavedTheme();
  }

  console.log('Theme switcher installed');
})();
