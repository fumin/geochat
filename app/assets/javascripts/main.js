if (window.location.pathname == "/") {

  // Listen for Server Sent Events
  getCurrentPosition(function(position){
    var log = function(str) {
      $("<div/>", {text: str}).prependTo($("#chat-space"));
    }
    var latitude  = position.coords.latitude;
    var longitude = position.coords.longitude;
    var path      = "stream?latitude=" + latitude + "&longitude=" + longitude;

    // Here we need to check for typeof(source) and make source a
    // global variable because turbolinks interferes with document.ready
    // causing duplicate EventSources to be created.
    if (typeof source == "undefined") {
      source = new EventSource(path);
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
    }
  },
  "We need your location to let you know what people around the area are saying."
  );
}

var index_page_init = function(){
if (window.location.pathname == "/") {

  // Form handler
  $("#say_form").submit(function(){
    getCurrentPosition(function(position){
        var url       = $("#say_form").attr("action");
        var data      = {
          msg:       $("#say_form > #msg").val(),
          latitude:  position.coords.latitude,
          longitude: position.coords.longitude,
          precision: $("#say_form > #precision").val()
        };
        jQuery.ajax({
          type: "POST",
          url: url,
          data: data,
          success: function(data){
            console.log(data);
          },
          error: function(jqXHR, textStatus, errorThrown){
            console.log(errorThrown);
          }});
      }, 
      "We need your location to send your message to people around you!"
    );
    return false; // disable the default form submission action
  });

} // if (window.location.pathname == "/") {


}; // var index_page_init = function(){


jQuery(document).on("page:load", index_page_init); // Turbolinks
jQuery(document).ready(index_page_init);
