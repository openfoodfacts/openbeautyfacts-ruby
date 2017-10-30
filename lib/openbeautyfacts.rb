require_relative 'openbeautyfacts/additive'
require_relative 'openbeautyfacts/brand'
require_relative 'openbeautyfacts/category'
require_relative 'openbeautyfacts/city'
require_relative 'openbeautyfacts/contributor'
require_relative 'openbeautyfacts/country'
require_relative 'openbeautyfacts/entry_date'
require_relative 'openbeautyfacts/faq'
require_relative 'openbeautyfacts/ingredient'
require_relative 'openbeautyfacts/ingredient_that_may_be_from_palm_oil'
require_relative 'openbeautyfacts/label'
require_relative 'openbeautyfacts/last_edit_date'
require_relative 'openbeautyfacts/locale'
require_relative 'openbeautyfacts/manufacturing_place'
require_relative 'openbeautyfacts/mission'
require_relative 'openbeautyfacts/number_of_ingredients'
require_relative 'openbeautyfacts/origin'
require_relative 'openbeautyfacts/packager_code'
require_relative 'openbeautyfacts/packaging'
require_relative 'openbeautyfacts/period_after_opening'
require_relative 'openbeautyfacts/press'
require_relative 'openbeautyfacts/product'
require_relative 'openbeautyfacts/product_state'
require_relative 'openbeautyfacts/purchase_place'
require_relative 'openbeautyfacts/store'
require_relative 'openbeautyfacts/trace'
require_relative 'openbeautyfacts/user'
require_relative 'openbeautyfacts/version'

require 'json'
require 'nokogiri'
require 'open-uri'

module Openbeautyfacts

  DEFAULT_LOCALE = Locale::GLOBAL
  DEFAULT_DOMAIN = 'openbeautyfacts.org'

  class << self

    # Return locale from link
    #
    def locale_from_link(link)
      Locale.locale_from_link(link)
    end

    # Get locales
    #
    def locales
      Locale.all
    end

    # Get product
    #
    def product(barcode, locale: DEFAULT_LOCALE)
      Product.get(barcode, locale: locale)
    end

    # Return product API URL
    #
    def product_url(barcode, locale: DEFAULT_LOCALE)
      Product.url(barcode, locale: locale)
    end

  end
end
