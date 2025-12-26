const RecentlyAdded = {

  get() {
    if (typeof games === 'undefined' || !games.length) {
      return [];
    }
    

    let recentGames = [...games];
    
    if (games[0]?.dateAdded) {
      recentGames.sort((a, b) => {
        const dateA = new Date(a.dateAdded).getTime();
        const dateB = new Date(b.dateAdded).getTime();
        return dateB - dateA;
      });
    }
    
    return recentGames.slice(0, 6);
  },


  render(container) {
    const recentGames = this.get();
    
    if (recentGames.length === 0) {
      container.innerHTML = `
        <div class="empty-state">
          <p>No games available yet.</p>
        </div>
      `;
      return;
    }

    container.innerHTML = recentGames.map(game => `
      <div class="game-card" data-game-id="${game.id}">
        <img src="${game.img}" alt="${game.title}" class="game-img" loading="lazy">
        <div class="game-info">
          <h3 class="game-title">${game.title}</h3>
          <button class="play-btn" onclick="RecentlyAdded.playGame('${game.id}')">Play</button>
        </div>
        ${game.dateAdded ? `<span class="new-badge">NEW</span>` : ''}
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
  const container = document.getElementById('recently-added-games');
  if (container) {
    RecentlyAdded.render(container);
  }
});