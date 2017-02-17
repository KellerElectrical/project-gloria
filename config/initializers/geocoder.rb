Geocoder.configure(
  # Geocoding options
  timeout: 10,                 # geocoding service timeout (secs)
  # lookup: :google,            # name of geocoding service (symbol)

  # language: :en,              # ISO-639 language code
  # use_https: false,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  # api_key: nil,               # API key for geocoding service
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #keys)
  # cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear
)

if %w(development test).include? Rails.env
  module Geocoder
    module Request
      def geocoder_spoofable_ip_with_localhost_override
        ip_candidate = geocoder_spoofable_ip_without_localhost_override
        if ip_candidate == '127.0.0.1'
          '1.2.3.4'
        else
          ip_candidate
        end
      end
      alias_method_chain :geocoder_spoofable_ip, :localhost_override
    end
  end
end