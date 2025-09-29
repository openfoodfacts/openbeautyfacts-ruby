# frozen_string_literal: true

module Openbeautyfacts
  class Additive < Openfoodfacts::Additive
    # Override constants for openbeautyfacts domain
    DEFAULT_LOCALE = Locale::GLOBAL
    DEFAULT_DOMAIN = 'openbeautyfacts.org'

    class << self
      # Override all method to use openbeautyfacts domain
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    # Override products method to use openbeautyfacts domain
    def products(page: -1)
      super(page: page)
    end
  end
end
