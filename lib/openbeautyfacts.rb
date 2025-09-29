# frozen_string_literal: true

require 'openfoodfacts'
require_relative 'openbeautyfacts/version'
require_relative 'openbeautyfacts/allergen'
require_relative 'openbeautyfacts/ingredient'
require_relative 'openbeautyfacts/period_after_opening'

# Override the openfoodfacts HTTP client to use openbeautyfacts domain
module Openfoodfacts
  def self.http_get(url)
    # Replace openfoodfacts.org with openbeautyfacts.org in URLs
    url = url.gsub('openfoodfacts.org', 'openbeautyfacts.org')
    
    user_agent = ENV.fetch('OPENBEAUTYFACTS_USER_AGENT', nil)
    headers = user_agent ? { 'User-Agent' => user_agent } : {}
    URI.parse(url).open(headers)
  end
end

module Openbeautyfacts
  DEFAULT_LOCALE = 'world'
  DEFAULT_DOMAIN = 'openbeautyfacts.org'

  # Create classes in Openbeautyfacts namespace that inherit from Openfoodfacts classes
  # but use the openbeautyfacts.org domain by default

  class Additive < Openfoodfacts::Additive
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Brand < Openfoodfacts::Brand
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Category < Openfoodfacts::Category
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class City < Openfoodfacts::City
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Contributor < Openfoodfacts::Contributor
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Country < Openfoodfacts::Country
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class EntryDate < Openfoodfacts::EntryDate
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Faq < Openfoodfacts::Faq
    class << self
      def items(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end
  end

  class IngredientThatMayBeFromPalmOil < Openfoodfacts::IngredientThatMayBeFromPalmOil
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Label < Openfoodfacts::Label
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Language < Openfoodfacts::Language
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class LastEditDate < Openfoodfacts::LastEditDate
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Locale < Openfoodfacts::Locale
    GLOBAL = 'world'

    class << self
      def all(domain: DEFAULT_DOMAIN)
        super(domain: domain)
      end

      def locale_from_link(link)
        super(link)
      end

      def locale_from_pair(pair, domain: DEFAULT_DOMAIN)
        super(pair, domain: domain)
      end
    end
  end

  class ManufacturingPlace < Openfoodfacts::ManufacturingPlace
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Mission < Openfoodfacts::Mission
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def fetch
      if url
        # Use openbeautyfacts domain for mission fetching
        super
      end
      self
    end
    alias reload fetch
  end

  class NumberOfIngredients < Openfoodfacts::NumberOfIngredients
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class NutritionGrade < Openfoodfacts::NutritionGrade
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Origin < Openfoodfacts::Origin
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class PackagerCode < Openfoodfacts::PackagerCode
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Packaging < Openfoodfacts::Packaging
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Press < Openfoodfacts::Press
    class << self
      def items(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end
  end

  class Product < Openfoodfacts::Product
    class << self
      def get(code, locale: DEFAULT_LOCALE)
        super(code, locale: locale)
      end
      alias find get

      def url(code, locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        if code
          path = "api/v0/produit/#{code}.json"
          "https://#{locale}.#{domain}/#{path}"
        end
      end

      def search(terms, locale: DEFAULT_LOCALE, page: 1, page_size: 20, sort_by: 'unique_scans_n', domain: DEFAULT_DOMAIN)
        super(terms, locale: locale, page: page, page_size: page_size, sort_by: sort_by, domain: domain)
      end
      alias where search

      def from_website_page(page_url, page: -1, products_count: nil)
        super(page_url, page: page, products_count: products_count)
      end

      def tags_from_page(_klass, page_url, &custom_tag_parsing)
        super(_klass, page_url, &custom_tag_parsing)
      end
    end

    def update(user: nil, domain: DEFAULT_DOMAIN)
      super(user: user, domain: domain)
    end
    alias save update

    def weburl(locale: nil, domain: DEFAULT_DOMAIN)
      super(locale: locale, domain: domain)
    end
  end

  class ProductState < Openfoodfacts::ProductState
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class PurchasePlace < Openfoodfacts::PurchasePlace
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Store < Openfoodfacts::Store
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class Trace < Openfoodfacts::Trace
    class << self
      def all(locale: DEFAULT_LOCALE, domain: DEFAULT_DOMAIN)
        super(locale: locale, domain: domain)
      end
    end

    def products(page: -1)
      Product.from_website_page(url, page: page, products_count: products_count) if url
    end
  end

  class User < Openfoodfacts::User
    def initialize(user_id: nil, password: nil)
      super(user_id: user_id, password: password)
    end
  end

  class << self
    # Centralized HTTP client method with User-Agent header, using openbeautyfacts domain
    #
    def http_get(url)
      # Replace openfoodfacts.org with openbeautyfacts.org in URLs
      url = url.gsub('openfoodfacts.org', 'openbeautyfacts.org')
      
      user_agent = ENV.fetch('OPENBEAUTYFACTS_USER_AGENT', nil)
      headers = user_agent ? { 'User-Agent' => user_agent } : {}
      URI.parse(url).open(headers)
    end

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
