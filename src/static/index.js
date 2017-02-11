// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed 

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ) );

var webcam = require ('../../node_modules/webcamjs/webcam.min.js');

var currentMsgId = null;
app.ports.webcam.subscribe(function (config) {
  currentMsgId = config.id;
  webcam.unfreeze();
  webcam.set(config);
  webcam.attach(currentMsgId);
});
app.ports.webcamReset.subscribe(function () {
  webcam.reset();
  currentMsgId = null;
  app.ports.webcamOff.send(null);
});

app.ports.webcamSnap.subscribe(function (msgId) {
  webcam.snap(function (dataUri) {
    var res = {"data_uri":dataUri, "msg_id" : msgId}
    if (currentMsgId === msgId) {
      app.ports.webcamDataUri.send(res);
    }
  });
  webcam.freeze();
});
app.ports.webcamConfig.subscribe(function (config) {
  webcam.set(config);
  app.ports.webcamConfiged.send(null)
});

app.ports.webcamAttach.subscribe(function (id) {
  webcam.attach(id);
  app.ports.webcamAttached.send(null);
});

app.ports.snap.subscribe(function () {
  webcam.snap(function (dataUri) {
    app.ports.snapped.send(dataUri);
  });
  webcam.reset();
});
