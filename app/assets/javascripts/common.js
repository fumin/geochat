function getCurrentPosition(handler, permission_error_msg) {
  navigator.geolocation.getCurrentPosition(
    handler,
    function(geo_error){
      if (1 == geo_error.code) { // Permission denied
        alert(perimssion_error_msg);
      } else {
        alert("Oops, location unavailable, please check your browser settings or try again.");
      }
    },
    {maximumAge: 75000} // 75 seconds
  );
};
