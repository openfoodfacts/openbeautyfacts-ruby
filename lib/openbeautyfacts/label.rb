module Openbeautyfacts
  class Label < Openfoodfacts::Label
    # Override constants for openbeautyfacts domain
    DEFAULT_LOCALE = Locale::GLOBAL
    DEFAULT_DOMAIN = 'openbeautyfacts.org'

    class << self
      # Override all method to use openbeautyfacts domain if it exists
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN, **options)
        super(locale: locale, domain: domain, **options)
      rescue NoMethodError
        # Method doesn't exist in parent class, skip
      end
    end

    # Override products method to use openbeautyfacts domain if it exists
    def products(page: -1)
      super(page: page)
    rescue NoMethodError
      # Method doesn't exist in parent class, skip
    end
  end
end
