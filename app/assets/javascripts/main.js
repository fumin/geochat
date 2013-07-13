if (window.location.pathname == "/") {

  log = function(str) {
    $("<div/>", {text: str}).appendTo($("#hello"));
  }

  var source = new EventSource("main/stream");
  source.addEventListener("message", function(e){
    var data = JSON.parse(e.data);
    var str = "time: " + data.time;
    console.log(data);
    log(str);
  }, false);
  source.addEventListener("custom", function(e){
    var data = JSON.parse(e.data);
    var str = "custom: " + data.i
    console.log(data);
    log(str);
  }, false);
}
