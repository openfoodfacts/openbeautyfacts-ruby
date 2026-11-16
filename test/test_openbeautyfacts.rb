# frozen_string_literal: true

require_relative 'minitest_helper'

class TestOpenbeautyfacts < Minitest::Test
  # Gem

  def test_that_it_has_a_version_number
    refute_nil ::Openbeautyfacts::VERSION
  end

  # Locale

  def test_it_fetches_locales
    VCR.use_cassette('index') do
      locales = ::Openbeautyfacts::Locale.all
      assert_includes locales.map { |locale| locale['code'] }, 'gd'
    end
  end

  # User

  def test_it_login_user
    VCR.use_cassette('login_user', record: :once, match_requests_on: %i[host path]) do
      user = ::Openbeautyfacts::User.login('wrong', 'absolutely')
      assert_nil user
    end
  end

  # Product

  def test_it_returns_product_url
    product = ::Openbeautyfacts::Product.new(code: '3600550362626')
    assert_equal ::Openbeautyfacts::Product.url(product.code, locale: 'ca'), product.url(locale: 'ca')
  end

  def test_it_returns_product_weburl
    product = ::Openbeautyfacts::Product.new(code: '3600550362626')
    assert_equal "https://world.openbeautyfacts.org/product/#{product.code}", product.weburl(locale: 'world')
  end

  def test_it_fetches_product
    product_code = '3600550362626'

    VCR.use_cassette("fetch_product_#{product_code}", record: :once, match_requests_on: %i[host path]) do
      product = ::Openbeautyfacts::Product.new(code: product_code)
      product.fetch
      refute_empty product.brands_tags
    end
  end

  def test_it_get_product
    product_code = '3600550362626'

    VCR.use_cassette("product_#{product_code}", record: :once, match_requests_on: %i[host path]) do
      assert_equal ::Openbeautyfacts::Product.get(product_code).code, product_code
    end
  end

  def test_that_it_search
    term = 'doux'

    VCR.use_cassette("search_#{term}") do
      products = ::Openbeautyfacts::Product.search(term, page_size: 24)
      assert_match(/#{term}/i, products.last['product_name'])
      assert_match(/#{term}/i, ::Openbeautyfacts::Product.search(term).last['product_name'])
      assert_equal products.size, 24
    end
  end

  def test_that_it_search_paginates
    term = 'doux'
    first_product = VCR.use_cassette("search_#{term}") { ::Openbeautyfacts::Product.search(term, page_size: 24).first }

    VCR.use_cassette("search_#{term}_1_000_000") do
      refute_equal ::Openbeautyfacts::Product.search(term, page: 2).first.code, first_product.code
    end
  end
end
