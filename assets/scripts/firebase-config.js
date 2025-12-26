const firebaseConfig = {
    apiKey: "AIzaSyC7zhMX7XGduwwtV7aH_ehON2eHI5jUenk",
    authDomain: "relic-ultimate.firebaseapp.com",
    databaseURL: "https://relic-ultimate-default-rtdb.firebaseio.com",
    projectId: "relic-ultimate",
    storageBucket: "relic-ultimate.firebasestorage.app",
    messagingSenderId: "1047341587934",
    appId: "1:1047341587934:web:0f40ca1d7a4ca72715114f"
}; // Added closing brace and semicolon

if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig);
}
