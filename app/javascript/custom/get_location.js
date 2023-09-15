document.addEventListener("turbo:load", function() {
  function getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition);
    } else {
      console.log("Geolocation is not supported by this browser.");
    }
  }

  function showPosition(position) {
    var lat = position.coords.latitude;
    var lon = position.coords.longitude;
    document.getElementById('user_latitude').value = lat;
    document.getElementById('user_longitude').value = lon;
  }
  getLocation();
});
