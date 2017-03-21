// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap/dist/js/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed

var webcam = require ('../../node_modules/webcamjs/webcam.min.js');


var jwt = "";
if (localStorage.jwt){
  jwt = localStorage.jwt;
}

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ),{jwt:jwt} );

app.ports.setLocalStorage.subscribe(function (keyVal) {
  localStorage.removeItem(keyVal.key);
  localStorage.setItem(keyVal.key,keyVal.value);
})

app.ports.removeLocalStorage.subscribe(function (keyVal) {
  localStorage.removeItem(keyVal.key);
})

var webcamId= "";
app.ports.webcamOn.subscribe(function (config) {
  webcamId= config.id;

  webcam.unfreeze();
  webcam.set(config);
  webcam.attach(id);
});
app.ports.webcamOff.subscribe(function () {
  webcam.reset()
});

app.ports.webcamSnap.subscribe(function () {
  webcam.snap(function (dataUri) {
    var res = {"data_uri":dataUri, "msg_id" : webcamId}
    app.ports.webcamDataUri.send(res);
  });
  webcam.freeze();
})
