// web/firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyAHpcaoL43w-v_t-9rRB5FqQVObB0-aHSw",
      authDomain: "health-1ac01.firebaseapp.com",
      projectId: "health-1ac01",
      storageBucket: "health-1ac01.appspot.com",
      messagingSenderId: "723775672508",
      appId: "1:723775672508:web:90dbd501a69f49647280b9",
});

const messaging = firebase.messaging();