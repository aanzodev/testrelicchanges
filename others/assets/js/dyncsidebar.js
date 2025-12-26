(function() {
  function lightenColor(color, amount = 0.15) {
    // Convert color to rbg
    let r, g, b, a = 1;
    
    // hex clors
    if (color.startsWith('#')) {
      const hex = color.replace('#', '');
      r = parseInt(hex.substr(0, 2), 16);
      g = parseInt(hex.substr(2, 2), 16);
      b = parseInt(hex.substr(4, 2), 16);
    }
    // Handle rgb/rgba colors
    else if (color.startsWith('rgb')) {
      const values = color.match(/[\d.]+/g);
      r = parseInt(values[0]);
      g = parseInt(values[1]);
      b = parseInt(values[2]);
      if (values[3]) a = parseFloat(values[3]);
    }
    // Default fallback
    else {
      return color;
    }
    
    // Lighten by moving towards white (255)
    r = Math.min(255, Math.round(r + (255 - r) * amount));
    g = Math.min(255, Math.round(g + (255 - g) * amount));
    b = Math.min(255, Math.round(b + (255 - b) * amount));
    
    return `rgba(${r}, ${g}, ${b}, 0.98)`;
  }

  function updateSidebarTheme() {
    // Get the current background color from CSS variables
    const rootStyles = getComputedStyle(document.documentElement);
    const bgColor = rootStyles.getPropertyValue('--bg-color').trim();
    
    if (bgColor) {
      // Calculate lighter versions for gradient
      const lighterStart = lightenColor(bgColor, 0.15);
      const lighterMid = lightenColor(bgColor, 0.20);
      const lighterEnd = lightenColor(bgColor, 0.15);
      
      // Apply to sidebar using CSS variables
      document.documentElement.style.setProperty('--sidebar-bg-start', lighterStart);
      document.documentElement.style.setProperty('--sidebar-bg-mid', lighterMid);
      document.documentElement.style.setProperty('--sidebar-bg-end', lighterEnd);
      
      console.log('✨ Sidebar theme updated:', {
        background: bgColor,
        sidebarStart: lighterStart,
        sidebarMid: lighterMid
      });
    }
  }

  // Update on page load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      setTimeout(updateSidebarTheme, 100);
    });
  } else {
    setTimeout(updateSidebarTheme, 100);
  }

  // 
  const themeSelect = document.getElementById('themeSelect');
  if (themeSelect) {
    themeSelect.addEventListener('change', function() {
      // Wait for theme to apply
      setTimeout(updateSidebarTheme, 150);
    });
  }

  
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if (mutation.attributeName === 'data-theme' || 
          mutation.attributeName === 'class' ||
          mutation.attributeName === 'style') {
        setTimeout(updateSidebarTheme, 100);
      }
    });
  });

  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['data-theme', 'class', 'style']
  });

  // Make function globally available
  window.updateSidebarTheme = updateSidebarTheme;

  console.log('🎨 Dynamic sidebar theme system initialized');
})();
