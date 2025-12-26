if (window.RelicConsole) {
  console.warn('RelicConsole already initialized');
} else {
  window.RelicConsole = {
    isOpen: false,
    logs: [],
    currentFilter: 'all',
    commandHistory: [],
    historyIndex: -1,
    originalConsole: {},
    initialized: false,
    autoOpenOnError: false, // Set to true if you want console to open on errors
    manuallyOpened: false, // Track if user has manually opened console

    init() {
      // Prevent double initialization
      if (this.initialized) {
        console.warn('RelicConsole already initialized');
        return;
      }
      this.initialized = true;

      // Create console HTML structure
      this.createConsoleHTML();
      
      this.container = document.getElementById('relic-console');
      this.output = document.getElementById('console-output');
      this.input = document.getElementById('console-input');

      // Intercept console methods BEFORE any other code runs
      this.interceptConsole();

      // Setup keyboard shortcuts
      document.addEventListener('keydown', (e) => {
        // Ctrl + Shift + K to toggle
        if (e.ctrlKey && e.shiftKey && e.key === 'K') {
          e.preventDefault();
          this.manuallyOpened = true; // Mark as manually opened
          this.toggle();
        }
      });

      // Setup input handlers
      this.input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
          this.executeCommand(this.input.value);
          this.input.value = '';
        } else if (e.key === 'ArrowUp') {
          e.preventDefault();
          this.navigateHistory(-1);
        } else if (e.key === 'ArrowDown') {
          e.preventDefault();
          this.navigateHistory(1);
        }
      });

      // Setup tab filters
      document.querySelectorAll('.console-tab').forEach(tab => {
        tab.addEventListener('click', () => {
          document.querySelectorAll('.console-tab').forEach(t => t.classList.remove('active'));
          tab.classList.add('active');
          this.currentFilter = tab.dataset.tab;
          this.render();
        });
      });

      this.updateTabCounts();

      this.addLog('Relic Console.', 'info');
      this.addLog('Press Ctrl+Shift+K to toggle console', 'info');
    },

    createConsoleHTML() {
      const consoleHTML = `
        <div id="relic-console">
          <div class="console-header">
            <div class="console-title">
              <span>⭐</span>
              <span>Relic Console</span>
            </div>
            <div class="console-controls">
              <button class="console-btn" onclick="RelicConsole.clear()">Clear</button>
              <button class="console-btn" onclick="RelicConsole.export()">Export</button>
              <button class="console-close" onclick="RelicConsole.close()">×</button>
            </div>
          </div>

          <div class="console-tabs">
            <button class="console-tab active" data-tab="all">All <span class="tab-count" id="count-all">0</span></button>
            <button class="console-tab" data-tab="log">Logs <span class="tab-count" id="count-log">0</span></button>
            <button class="console-tab" data-tab="warn">Warnings <span class="tab-count" id="count-warn">0</span></button>
            <button class="console-tab" data-tab="error">Errors <span class="tab-count" id="count-error">0</span></button>
            <button class="console-tab" data-tab="info">Info <span class="tab-count" id="count-info">0</span></button>
          </div>

          <div class="console-output" id="console-output"></div>

          <div class="console-input-container">
            <span class="console-prompt">&gt;</span>
            <input type="text" class="console-input" id="console-input" placeholder="Type JavaScript code here..." />
          </div>
        </div>
      `;

      document.body.insertAdjacentHTML('beforeend', consoleHTML);
    },

    interceptConsole() {
      // Check if already intercepted
      if (this.originalConsole.log) {
        return;
      }

      // Store original console methods
      this.originalConsole.log = console.log.bind(console);
      this.originalConsole.warn = console.warn.bind(console);
      this.originalConsole.error = console.error.bind(console);
      this.originalConsole.info = console.info.bind(console);
      this.originalConsole.debug = console.debug.bind(console);

      // Override console.log
      console.log = (...args) => {
        this.originalConsole.log(...args);
        this.addLog(args.map(arg => this.formatArg(arg)).join(' '), 'log');
      };

      // Override console.warn
      console.warn = (...args) => {
        this.originalConsole.warn(...args);
        this.addLog(args.map(arg => this.formatArg(arg)).join(' '), 'warn');
      };

      // Override console.error
      console.error = (...args) => {
        this.originalConsole.error(...args);
        this.addLog(args.map(arg => this.formatArg(arg)).join(' '), 'error');
        
        // Only auto-open on error if enabled
        if (this.autoOpenOnError && !this.isOpen) {
          this.open();
        }
      };

      // Override console.info
      console.info = (...args) => {
        this.originalConsole.info(...args);
        this.addLog(args.map(arg => this.formatArg(arg)).join(' '), 'info');
      };

      // Override console.debug
      console.debug = (...args) => {
        this.originalConsole.debug(...args);
        this.addLog(args.map(arg => this.formatArg(arg)).join(' '), 'log');
      };

      // Capture window errors (including syntax errors)
      window.addEventListener('error', (e) => {
        // Check if it's a script error
        if (e.target === window) {
          const message = `${e.message} at ${e.filename}:${e.lineno}:${e.colno}`;
          this.addLog(message, 'error');
          
          // Only auto-open on error if enabled
          if (this.autoOpenOnError && !this.isOpen) {
            this.open();
          }
        } else if (e.target.tagName === 'IMG' || e.target.tagName === 'SCRIPT' || e.target.tagName === 'LINK') {
          // Resource loading errors
          const message = `Failed to load resource: ${e.target.src || e.target.href}`;
          this.addLog(message, 'error');
        }
      }, true);

      // Capture unhandled promise rejections
      window.addEventListener('unhandledrejection', (e) => {
        const message = `Unhandled Promise Rejection: ${e.reason}`;
        this.addLog(message, 'error');
        
        // Only auto-open on error if enabled
        if (this.autoOpenOnError && !this.isOpen) {
          this.open();
        }
      });
    },

    formatArg(arg) {
      if (arg === null) return 'null';
      if (arg === undefined) return 'undefined';
      
      if (typeof arg === 'object') {
        try {
          // Handle special objects
          if (arg instanceof Error) {
            return `${arg.name}: ${arg.message}\n${arg.stack || ''}`;
          }
          if (arg instanceof HTMLElement) {
            return `<${arg.tagName.toLowerCase()}${arg.id ? ' id="' + arg.id + '"' : ''}${arg.className ? ' class="' + arg.className + '"' : ''}>`;
          }
          // Regular objects
          return JSON.stringify(arg, null, 2);
        } catch (e) {
          return String(arg);
        }
      }
      
      return String(arg);
    },

    addLog(message, type = 'log') {
      const timestamp = new Date().toLocaleTimeString();
      const log = { message, type, timestamp };
      this.logs.push(log);

      // Limit to 1000 logs
      if (this.logs.length > 1000) {
        this.logs.shift();
      }

      // Update tab counts
      this.updateTabCounts();

      // Render if console is open
      if (this.isOpen) {
        this.render();
      }
    },

    updateTabCounts() {
      const counts = {
        all: this.logs.length,
        log: this.logs.filter(l => l.type === 'log').length,
        warn: this.logs.filter(l => l.type === 'warn').length,
        error: this.logs.filter(l => l.type === 'error').length,
        info: this.logs.filter(l => l.type === 'info').length
      };

      Object.keys(counts).forEach(type => {
        const countElement = document.getElementById(`count-${type}`);
        if (countElement) {
          countElement.textContent = counts[type];
        }
      });
    },

    render() {
      const filtered = this.currentFilter === 'all' 
        ? this.logs 
        : this.logs.filter(log => log.type === this.currentFilter);

      this.output.innerHTML = filtered.map(log => {
        const typeLabel = log.type.toUpperCase();
        const typeIcon = {
          log: '📝',
          warn: '⚠️',
          error: '❌',
          info: 'ℹ️',
          debug: '🐛'
        }[log.type] || '📝';

        return `
          <div class="console-log ${log.type}">
            <span class="log-icon">${typeIcon}</span>
            <span class="log-timestamp">${log.timestamp}</span>
            <span class="log-type">[${typeLabel}]</span>
            <span class="log-message">${this.escapeHtml(log.message)}</span>
          </div>
        `;
      }).join('');

      // Auto-scroll to bottom
      this.output.scrollTop = this.output.scrollHeight;
    },

    executeCommand(code) {
      if (!code.trim()) return;

      this.commandHistory.push(code);
      this.historyIndex = this.commandHistory.length;

      this.addLog(`> ${code}`, 'debug');

      try {
        const result = eval(code);
        if (result !== undefined) {
          this.addLog(`← ${this.formatArg(result)}`, 'log');
        }
      } catch (error) {
        this.addLog(`Error: ${error.message}`, 'error');
      }
    },

    navigateHistory(direction) {
      this.historyIndex += direction;
      if (this.historyIndex < 0) this.historyIndex = 0;
      if (this.historyIndex > this.commandHistory.length) {
        this.historyIndex = this.commandHistory.length;
      }

      if (this.historyIndex < this.commandHistory.length) {
        this.input.value = this.commandHistory[this.historyIndex];
      } else {
        this.input.value = '';
      }
    },

    toggle() {
      if (this.isOpen) {
        this.close();
      } else {
        this.manuallyOpened = true;
        this.open();
      }
    },

    open() {
      this.isOpen = true;
      this.container.classList.add('open');
      this.render();
      this.input.focus();
    },

    close() {
      this.isOpen = false;
      this.container.classList.remove('open');
    },

    clear() {
      this.logs = [];
      this.render();
      this.updateTabCounts();
      this.addLog('Console cleared', 'info');
    },

    export() {
      const text = this.logs.map(log => 
        `[${log.timestamp}] [${log.type.toUpperCase()}] ${log.message}`
      ).join('\n');

      const blob = new Blob([text], { type: 'text/plain' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `Relic-console-${Date.now()}.txt`;
      a.click();
      URL.revokeObjectURL(url);

      this.addLog('Console logs exported', 'info');
    },

    escapeHtml(text) {
      const div = document.createElement('div');
      div.textContent = text;
      return div.innerHTML;
    }
  };

  // Initialize console as early as possible
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => window.RelicConsole.init());
  } else {
    window.RelicConsole.init();
  }
}
