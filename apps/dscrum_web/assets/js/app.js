// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
//import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"
import User from "./user"
// Demo by http://creative-punch.net

// // Check for the File API support.
// if (window.File && window.FileReader && window.FileList && window.Blob) {
//   document.getElementById('user_schema_image').addEventListener('change', handleFileSelect, false);
// } else {
//   alert('The File APIs are not fully supported in this browser.');
// }

// function handleFileSelect(evt) {
//   var f = evt.target.files[0]; // FileList object
//   var reader = new FileReader();
//   // Closure to capture the file information.
//   reader.onload = (function(theFile) {
//     return function(e) {
//       var binaryData = e.target.result;
//       //Converting Binary Data to base 64
//       var base64String = window.btoa(binaryData);
//       //showing file converted to base64
//       document.getElementById('base64').value = base64String;
//       alert('File converted to base64 successfuly!\nCheck in Textarea');
//     };
//   })(f);
//   // Read in the image file as a data URL.
//   reader.readAsBinaryString(f);
// }

// cargar foto preview
function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        
        reader.onload = function (e) {
            $('#blah').attr('src', e.target.result);
        }
        
        reader.readAsDataURL(input.files[0]);
    }
}

$("#user_schema_foto").change(function(){
    readURL(this);
});

$("#team_schema_foto").change(function(){
    readURL(this);
});

// fin cargar foto preview

// modal
$(document).ready(function(){
    $('.modal').modal();
  });


$("#send-button").click(function(){
    $('.modal').modal('close');
});

// fin modal

User.init(socket, document.getElementById("records-user"))
