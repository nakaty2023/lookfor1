Geocoder.configure(
  timeout: 3,                 # geocoding service timeout (secs)
  lookup: :google,            # name of geocoding service (see below for supported options)
  language: :ja,              # ISO-639 language code
  use_https: true, # use HTTPS for lookup requests? (if supported)
  api_key: ENV.fetch('GOOGLE_API_KEY', nil)   # API key for geocoding service
)
