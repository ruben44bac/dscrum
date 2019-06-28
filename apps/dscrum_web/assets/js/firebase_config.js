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

  // Retrieve Firebase Messaging object.
  const messaging = firebase.messaging();

  // Add the public key generated from the console here.
  messaging.usePublicVapidKey("BElORGVIIKXRAgZLsd72AGxLf7ch7T4ie_ThzlXt4WLy5ti2x8PXMQ9QmEY_nxuwLv_3VH_7Onr-YQ3VnOxBp3U");

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
    
    console.log(payload);
  });