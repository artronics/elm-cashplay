// var webcam = require ('../../node_modules/webcamjs/webcam.min.js');

var  _moarwick$elm_webpack_starter$Native_Webcam = function () {

  var config = function (config) {
    console.log("kirrrrrrrrrrr");
    window.webcam.set(config);
  }
  var attach = function (id) {
    webcam.attach(id);
  }

  var snap = function () {
    webcam.snap();
  }
  var reset = function () {
    webcam.reset();
  }

  return {
    config:config,
    attach: attach,
    snap: snap,
    reset:reset
  }
}();



