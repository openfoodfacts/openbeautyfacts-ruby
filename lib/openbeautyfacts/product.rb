# frozen_string_literal: true

module Openbeautyfacts
  # Open Beauty Facts product resource.
  class Product < Openfoodfacts::Product
    # Override constants for openbeautyfacts domain
    DEFAULT_LOCALE = Locale::GLOBAL
    DEFAULT_DOMAIN = 'openbeautyfacts.org'

    # OpenBeautyFacts uses the same URL prefixes as OpenFoodFacts
    LOCALE_WEBURL_PREFIXES = {
      'fr' => 'produit',
      'uk' => 'product',
      'us' => 'product',
      'world' => 'product'
    }.freeze

    class << self
      # Override URL method to use openbeautyfacts domain
      def url(code, locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(code, locale: locale, domain: domain)
      end

      # Override search method to use openbeautyfacts domain
      def search(terms, domain: DEFAULT_DOMAIN, **options)
        super(terms, domain: domain, **options)
      end
    end

    # Override weburl method to use openbeautyfacts domain
    def weburl(locale: nil, domain: DEFAULT_DOMAIN)
      super(locale: locale, domain: domain)
    end

    # Override update method to use openbeautyfacts domain
    def update(user: nil, domain: DEFAULT_DOMAIN)
      super(user: user, domain: domain)
    end
  end
end
