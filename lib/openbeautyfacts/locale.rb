module Openbeautyfacts
  class Locale < Openfoodfacts::Locale
    # Override constants for openbeautyfacts domain
    GLOBAL = 'world'
    DEFAULT_DOMAIN = 'openbeautyfacts.org'

    class << self
      # Override all method to use openbeautyfacts domain
      def all(domain: DEFAULT_DOMAIN)
        super(domain: domain)
      end

      # Override locale_from_pair method to use openbeautyfacts domain
      def locale_from_pair(pair, domain: DEFAULT_DOMAIN)
        super(pair, domain: domain)
      end
    end
  end
end
