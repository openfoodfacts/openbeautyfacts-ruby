require 'hashie'

module Openbeautyfacts
  class PeriodAfterOpening < Hashie::Mash

    # TODO: Add more locales
    LOCALE_PATHS = {
      'fr' => 'durees-d-utilisation-apres-ouverture',
      'uk' => 'periods-after-opening',
      'us' => 'periods-after-opening',
      'world' => 'periods-after-opening'
    }

    class << self

      # Get last edit dates
      #
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        if path = LOCALE_PATHS[locale]
          Product.tags_from_page(self, "https://#{locale}.#{domain}/#{path}")
        end
      end

    end

    # Get products with last edit date
    #
    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end

  end
end
