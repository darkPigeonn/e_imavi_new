importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
    apiKey: "AIzaSyDCdkNoArtxUolzKtoWgFemVxZZ11aAX8A",
    authDomain: "imavistatic.firebaseapp.com",
    projectId: "imavistatic",
    storageBucket: "imavistatic.appspot.com",
    messagingSenderId: "859691038944",
    appId: "1:859691038944:web:3bd1318f040dab7a5f7885",
    measurementId: "G-Y2WXQ2SWLH"
  };

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});