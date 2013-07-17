var index_page_init = function(){
if (window.location.pathname == "/") {

  // Server sent events
  log = function(str) {
    $("<div/>", {text: str}).prependTo($("#chat-space"));
  }

  var source = new EventSource("stream");
  source.addEventListener("message", function(e){
    var data = JSON.parse(e.data);
    var str = "time: " + data.time;
    console.log(data);
    log(str);
  }, false);
  source.addEventListener("custom", function(e){
    var data = JSON.parse(e.data);
    var str = "msg: " + data.msg +
              ", latitude: " + data.latitude +
              ", longitude: " + data.longitude;
    console.log(data);
    log(str);
  }, false);

  // Form handler
  $("#say_form").submit(function(){
    navigator.geolocation.getCurrentPosition(function(position){
      var latitude  = position.coords.latitude;
      var longitude = position.coords.longitude;
      var url       = $("#say_form").attr("action");
      var data      = {
        msg: $("#msg").val(),
        latitude: position.coords.latitude,
        longitude: position.coords.longitude
      };
      jQuery.ajax({
        type: "POST",
        url: url,
        data: data,
        success: function(data){
          console.log(data);
        },
        error: function(jqXHR, textStatus, errorThrown){
          alert(jqXHR);
        }});
    }, 
    function(geo_error){
      if (1 == geo_error.code) { // Permission denied
        alert("We need your location to send your message to people around you!");
      } else {
        alert("Oops, location unavailable, please check your browser settings or try again.");
      }
    },
    {maximumAge: 75000} // 75 seconds
    ); // getCurrentPosition

    return false; // disable the default form submission action
  }); // $("#say_form").submit(function(){

} // if (window.location.pathname == "/") {


}; // var index_page_init = function(){


jQuery(document).on("page:load", index_page_init); // Turbolinks
jQuery(document).ready(index_page_init);
