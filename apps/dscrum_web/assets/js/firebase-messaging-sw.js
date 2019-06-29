importScripts('https://www.gstatic.com/firebasejs/6.2.4/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/6.2.4/firebase-messaging.js');


//Your web app's Firebase configuration
// var firebaseConfig = {
//     apiKey: "AIzaSyCYOz-otfUSB8yEmxmfOmGlX6uZtoftgZI",
//     authDomain: "santiago-notificaciones.firebaseapp.com",
//     databaseURL: "https://santiago-notificaciones.firebaseio.com",
//     projectId: "santiago-notificaciones",
//     storageBucket: "",
//     messagingSenderId: "1049196734529",
//     appId: "1:1049196734529:web:ed39a51af4c291a7"
// };
// // Initialize Firebase
// firebase.initializeApp(firebaseConfig);

// var messaging = firebase.messaging();

// messaging.setBackgroundMessageHandler(function(payload) {
//     console.log('[firebase-messaging-sw.js] Received background message ', payload);
//     // Customize notification here
//     var notificationTitle = payload.notification.title;
//     var notificationOptions = {
//       body: payload.notification.body,
//       image: payload.notification.image,
//       icon: payload.notification.image
//     };
  
//     console.log(notificationOptions);
//     return self.registration.showNotification(notificationTitle,
//       notificationOptions);
//   });

var action = "";

self.addEventListener('push', function(event) {

    var json = JSON.parse(event.data.text());
    const title = json.notification.title;
    action = json.notification.click_action
    const options = {
        body: json.notification.body,
        icon: json.data["gcm.notification.image"],
        badge: json.data["gcm.notification.image"],
        image: json.data["gcm.notification.image"]
    };

    event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', function(event) {
    console.log(action);

    event.notification.close();

    event.waitUntil(
        clients.openWindow('https://santiago.mx/home')
    );
});