const RecentlyPlayed = {
  storageKey: 'relic_recently_played',
  maxItems: 6,


  get() {
    try {
      const stored = localStorage.getItem(this.storageKey);
      return stored ? JSON.parse(stored) : [];
    } catch (e) {
      console.error('Error reading recently played:', e);
      return [];
    }
  },


  add(game) {
    try {
      let recent = this.get();
      

      recent = recent.filter(g => g.id !== game.id);
      

      recent.unshift({
        id: game.id,
        title: game.title,
        img: game.img,
        file: game.file,
        timestamp: Date.now()
      });
      

      recent = recent.slice(0, this.maxItems);
      
      localStorage.setItem(this.storageKey, JSON.stringify(recent));
      

      this.refresh();
    } catch (e) {
      console.error('Error saving recently played:', e);
    }
  },


  clear() {
    try {
      localStorage.removeItem(this.storageKey);
      this.refresh();
    } catch (e) {
      console.error('Error clearing recently played:', e);
    }
  },


  refresh() {
    const container = document.getElementById('recently-played-games');
    if (container) {
      this.render(container);
    }
  },


  render(container) {
    const recent = this.get();
    
    if (recent.length === 0) {
      container.innerHTML = `
        <div class="empty-state">
          <p>No games played yet. Start playing to see your history!</p>
        </div>
      `;
      return;
    }

    container.innerHTML = recent.map(game => `
      <div class="game-card" data-game-id="${game.id}">
        <img src="${game.img}" alt="${game.title}" class="game-img" loading="lazy">
        <div class="game-info">
          <h3 class="game-title">${game.title}</h3>
          <button class="play-btn" onclick="RecentlyPlayed.playGame('${game.id}')">Play</button>
        </div>
      </div>
    `).join('');
  },

  playGame(gameId) {

    if (typeof games !== 'undefined') {
      const game = games.find(g => g.id === gameId);
      if (game && typeof loadGame === 'function') {
        loadGame(game);
      }
    }
  }
};


document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('recently-played-games');
  if (container) {
    RecentlyPlayed.render(container);
  }
});