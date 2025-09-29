module Openbeautyfacts
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
      def search(terms, locale: DEFAULT_LOCALE, page: 1, page_size: 20, sort_by: 'unique_scans_n', domain: DEFAULT_DOMAIN)
        super(terms, locale: locale, page: page, page_size: page_size, sort_by: sort_by, domain: domain)
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