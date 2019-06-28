importScripts('https://www.gstatic.com/firebasejs/6.2.4/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/6.2.4/firebase-messaging.js');


//Your web app's Firebase configuration
var firebaseConfig = {
    apiKey: "AIzaSyD4gmdksFaSPkXMMfbPYOyRtyagX3q2BPY",
    authDomain: "prueba-cf0a1.firebaseapp.com",
    databaseURL: "https://prueba-cf0a1.firebaseio.com",
    projectId: "prueba-cf0a1",
    storageBucket: "",
    messagingSenderId: "360258019631",
    appId: "1:360258019631:web:ae0f08d66415ac36"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);

var messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    // Customize notification here
    var notificationTitle = 'Background Message Title';
    var notificationOptions = {
      body: 'Background Message body.',
      icon: '/firebase-logo.png'
    };
  
    return self.registration.showNotification(notificationTitle,
      notificationOptions);
  });

// var action = "";

// self.addEventListener('push', function(event) {
//     var json = JSON.parse(event.data.text())
//     const title = json.notification.title;

//     action = json.notification.click_action
//     const options = {
//         body: json.notification.body,
//         icon: '/images/notdsa.png',
//         badge: '/images/notdsa.png',
//         image: json.data["gcm.notification.image"],
//         onclick: json.notification.click_action,
//         click_action: json.notification.click_action
//     };

//     event.waitUntil(self.registration.showNotification(title, options));
// });

// self.addEventListener('notificationclick', function(event) {
//     console.log('[Service Worker] Notification click Received.');
//     console.log(action);

//     event.notification.close();

//     event.waitUntil(
//         clients.openWindow('https://developers.google.com/web/')
//     );
// });