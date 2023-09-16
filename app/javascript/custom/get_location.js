document.addEventListener("turbo:load", function() {
  var searchButton = document.getElementById('search_button');

  function getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition, showError);
    } else {
      console.log("Geolocation is not supported by this browser.");
    }
  }

  function showPosition(position) {
    var lat = position.coords.latitude;
    var lon = position.coords.longitude;
    document.getElementById('user_latitude').value = lat;
    document.getElementById('user_longitude').value = lon;
    searchButton.removeAttribute('disabled');
  }

  function showError(error) {
    console.log("Unable to get location: ", error);
    searchButton.removeAttribute('disabled');
  }

  getLocation();
});
