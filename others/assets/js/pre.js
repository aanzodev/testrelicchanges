"use strict";

// Safely check if elements exist before using them
function getElement(id) {
  const element = document.getElementById(id);
  if (!element) {
    console.warn(`Element with id "${id}" not found`);
  }
  return element;
}

function getElementBySelector(selector) {
  const element = document.querySelector(selector);
  if (!element) {
    console.warn(`Element with selector "${selector}" not found`);
  }
  return element;
}

const stockSW = "./sw.js";
const swAllowedHostnames = ["localhost", "127.0.0.1"];

// Get elements safely
const form = getElement("form");
const address = getElement("address");
const autoc = getElement("autoc");
const wContainer = getElementBySelector(".w-container");
const backBtn = getElement("backBtn");
const forwardBtn = getElement("forwardBtn");
const reloadBtn = getElement("reloadBtn");
const fullscreenBtn = getElement("fullscreenBtn");
const closeBtn = getElement("closeBtn");
let frame = getElement("frame");
let timeout;

// Initialize BareMux connection safely
let connection = null;
let scramjet = null;

try {
  if (typeof BareMux !== 'undefined') {
    connection = new BareMux.BareMuxConnection("/mux/worker.js");
    console.log('BareMux connection initialized');
  } else {
    console.warn('BareMux is not loaded. Proxy features will not be available.');
  }
} catch (err) {
  console.error('Error initializing BareMux:', err);
}

// Initialize Scramjet safely
try {
  if (typeof $scramjetLoadController !== 'undefined') {
    const { ScramjetController } = $scramjetLoadController();
    scramjet = new ScramjetController({
      files: {
        wasm: "https://cdn.jsdelivr.net/gh/soap-phia/tinyjet@latest/tinyjet/scramjet.wasm.js",
        all: "https://cdn.jsdelivr.net/gh/soap-phia/tinyjet@latest/tinyjet/scramjet.all.js",
        sync: "https://cdn.jsdelivr.net/gh/soap-phia/tinyjet@latest/tinyjet/scramjet.sync.js",
      },
    });
    scramjet.init();
    console.log('Scramjet initialized');
  } else {
    console.warn('Scramjet is not loaded. Encoding features will not be available.');
  }
} catch (err) {
  console.error('Error initializing Scramjet:', err);
}

async function registerSW() {
  if (!navigator.serviceWorker) {
    if (
      location.protocol !== "https:" &&
      !swAllowedHostnames.includes(location.hostname)
    )
      throw new Error("Service workers cannot be registered without https.");

    throw new Error("Your browser doesn't support service workers.");
  }

  try {
    const registration = await navigator.serviceWorker.register(stockSW);
    console.log('Service Worker registered successfully:', registration);
    
    // Wait for service worker to be ready
    await navigator.serviceWorker.ready;
    console.log('Service Worker is ready');
    
    return registration;
  } catch (err) {
    console.error('Service Worker registration failed:', err);
    throw err;
  }
}

function search(input, template) {
  try {
    return new URL(input).toString();
  } catch (err) {}

  try {
    const url = new URL(`http://${input}`);
    if (url.hostname.includes(".")) return url.toString();
  } catch (err) {}
  
  return template.replace("%s", encodeURIComponent(input));
}

// Form submit handler - only if form exists
if (form && address && frame) {
  form.addEventListener("submit", async (event) => {
    event.preventDefault();

    if (!connection || !scramjet) {
      console.error('Proxy system not initialized. Cannot navigate.');
      alert('Proxy features are not available. Please refresh the page.');
      return;
    }

    try {
      await registerSW();
    } catch (err) {
      console.error('Service Worker registration failed:', err);
      alert('Could not initialize proxy. Please check console for details.');
      return;
    }

    const url = search(address.value, "https://duckduckgo.com/?q=%s");

    frame.style.display = "block";
    let wispUrl =
      (location.protocol === "https:" ? "wss" : "ws") +
      "://" +
      location.host +
      "/wisp/";
    
    try {
      if ((await connection.getTransport()) !== "/ep/index.mjs") {
        await connection.setTransport("/ep/index.mjs", [{ wisp: wispUrl }]);
      }
      console.log('Transport set:', wispUrl);
    } catch (err) {
      console.error('Error setting transport:', err);
    }

    const sjEncode = scramjet.encodeUrl.bind(scramjet);
    frame.src = sjEncode(url);
    
    if (wContainer) {
      wContainer.classList.add("show");
    }
    if (autoc) {
      autoc.classList.remove("show");
    }

    // Handle cursor safely
    const cursor = getElement("cursor");
    if (cursor) {
      cursor.style.opacity = 0;
    }
    document.documentElement.style.cursor = "auto";
    document.body.style.cursor = "auto";
  });
}

// Frame load handler
if (frame && scramjet) {
  frame.addEventListener("load", () => {
    try {
      const url = scramjet.decodeUrl(frame.src);
      console.log('Frame loaded:', url);
      const urlInput = getElement("urlInput");
      if (urlInput) {
        urlInput.value = url;
      }
    } catch (err) {
      console.error('Error decoding URL:', err);
    }
  });
}

// Address input autocomplete
if (address && autoc) {
  address.addEventListener("input", (e) => {
    clearTimeout(timeout);
    timeout = setTimeout(async () => {
      const query = e.target.value.trim();
      if (query.length > 0) {
        try {
          const response = await fetch(`/autoc?q=${encodeURIComponent(query)}`);
          if (!response.ok) {
            console.error("autocomplete request failed", response.status);
            return;
          }
          const suggestions = await response.json();
          autoc.innerHTML = "";
          if (suggestions.length > 0) {
            for (const suggestion of suggestions) {
              const div = document.createElement("div");
              div.classList.add("autoc-item");
              div.textContent = suggestion.phrase;
              div.addEventListener("click", () => {
                address.value = suggestion.phrase;
                if (form) {
                  form.requestSubmit();
                }
                autoc.classList.remove("show");
              });
              autoc.appendChild(div);
            }
            autoc.classList.add("show");
          } else {
            autoc.classList.remove("show");
          }
        } catch (err) {
          console.log("autocomplete failed: " + err);
        }
      } else {
        autoc.classList.remove("show");
      }
    }, 300);
  });
}

// Navigation buttons
if (backBtn && frame) {
  backBtn.addEventListener("click", () => {
    if (frame.contentWindow) {
      frame.contentWindow.history.back();
    }
  });
}

if (forwardBtn && frame) {
  forwardBtn.addEventListener("click", () => {
    if (frame.contentWindow) {
      frame.contentWindow.history.forward();
    }
  });
}

if (reloadBtn && frame) {
  reloadBtn.addEventListener("click", () => {
    frame.src = frame.src;
  });
}

if (fullscreenBtn && frame) {
  fullscreenBtn.addEventListener("click", () => {
    if (!document.fullscreenElement) {
      frame.requestFullscreen().catch((err) => {
        console.error(`Error attempting to enable fullscreen: ${err.message}`);
      });
    } else {
      document.exitFullscreen();
    }
  });
}

if (closeBtn && frame) {
  closeBtn.addEventListener("click", () => {
    frame.src = "about:blank";
    const center = getElementBySelector(".center");
    if (center) {
      center.style.display = "flex";
    }
    if (wContainer) {
      wContainer.classList.remove("show");
    }
    frame.style.display = "none";
    
    const cursor = getElement("cursor");
    if (cursor) {
      cursor.style.opacity = 1;
    }
    document.documentElement.style.cursor = "none";
    document.body.style.cursor = "none";
  });
}

// URL form handler
const urlForm = getElement("urlForm");
if (urlForm && frame) {
  urlForm.addEventListener("submit", async (event) => {
    event.preventDefault();

    if (!connection || !scramjet) {
      console.error('Proxy system not initialized. Cannot navigate.');
      alert('Proxy features are not available. Please refresh the page.');
      return;
    }

    try {
      await registerSW();
    } catch (err) {
      console.error('Service Worker registration failed:', err);
      alert('Could not initialize proxy. Please check console for details.');
      return;
    }

    const urlInput = getElement("urlInput");
    if (!urlInput) return;

    const url = search(
      urlInput.value,
      "https://duckduckgo.com/?q=%s"
    );

    frame.style.display = "block";
    let wispUrl =
      (location.protocol === "https:" ? "wss" : "ws") +
      "://" +
      location.host +
      "/wisp/";

    try {
      if ((await connection.getTransport()) !== "/ep/index.mjs") {
        await connection.setTransport("/ep/index.mjs", [{ wisp: wispUrl }]);
      }
      console.log('Transport set:', wispUrl);
    } catch (err) {
      console.error('Error setting transport:', err);
    }

    const sjEncode = scramjet.encodeUrl.bind(scramjet);
    frame.src = sjEncode(url);
  });
}

console.log('pre.js loaded successfully');
