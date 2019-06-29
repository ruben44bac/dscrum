var firebaseConfig = {
  apiKey: "AIzaSyCYOz-otfUSB8yEmxmfOmGlX6uZtoftgZI",
  authDomain: "santiago-notificaciones.firebaseapp.com",
  databaseURL: "https://santiago-notificaciones.firebaseio.com",
  projectId: "santiago-notificaciones",
  storageBucket: "",
  messagingSenderId: "1049196734529",
  appId: "1:1049196734529:web:ed39a51af4c291a7"
};
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);

  // Retrieve Firebase Messaging object.
  const messaging = firebase.messaging();

  // Add the public key generated from the console here.
  messaging.usePublicVapidKey("BC6-oiITXYcQuJJq8GmTW0IoqzhtU--7s-P-9ry39mru2NkfcGBxvPqGW2B1VufjZqStkQJIEpWprqKiwFpFqUE");

  messaging.requestPermission()
  .then(function() {
    console.log('Notification permission granted.');
    return messaging.getToken();
  })
  .then(function(token) {
    console.log(token);
  }).catch(function(err) {
    console.log('Unable to get permission to notify.', err);
  });

  messaging.onMessage(function(payload) {
    console.log("Hola")
    console.log(payload);
  });