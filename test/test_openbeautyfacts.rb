require_relative 'minitest_helper'

class TestOpenbeautyfacts < Minitest::Test

  # Gem

  def test_that_it_has_a_version_number
    refute_nil ::Openbeautyfacts::VERSION
  end

  # Locale

  def test_it_fetches_locales
    VCR.use_cassette("index") do
      locales = ::Openbeautyfacts::Locale.all
      assert_includes locales, "world"
      assert_includes locales, "fr"
      assert_includes locales, "es-gl"
    end
  end

  # User

  def test_it_login_user
    VCR.use_cassette("login_user", record: :once, match_requests_on: [:host, :path]) do
      user = ::Openbeautyfacts::User.login("wrong", "absolutely")
      assert_nil user
    end
  end

  # Product

  def test_it_returns_product_url
    product = ::Openbeautyfacts::Product.new(code: "3600550362626")
    assert_equal ::Openbeautyfacts::Product.url(product.code, locale: 'ca'), product.url(locale: 'ca')
  end

  def test_it_returns_product_weburl
    product = ::Openbeautyfacts::Product.new(code: "3600550362626")
    assert_equal "http://world.openbeautyfacts.org/product/#{product.code}", product.weburl(locale: 'world')
  end

  def test_it_fetches_product
    product_code = "3600550362626"

    VCR.use_cassette("fetch_product_#{product_code}", record: :once, match_requests_on: [:host, :path]) do
      product = ::Openbeautyfacts::Product.new(code: product_code)
      product.fetch
      refute_empty product.brands_tags
    end
  end

  def test_it_get_product
    product_code = "3600550362626"

    VCR.use_cassette("product_#{product_code}", record: :once, match_requests_on: [:host, :path]) do
      assert_equal ::Openbeautyfacts::Product.get(product_code).code, product_code
    end
  end

  def test_that_it_search
    term = "doux"
    first_product = nil

    VCR.use_cassette("search_#{term}") do
      products = ::Openbeautyfacts::Product.search(term, page_size: 24)
      first_product = products.first

      assert_match /#{term}/i, products.last["product_name"]
      assert_match /#{term}/i, ::Openbeautyfacts::Product.search(term).last["product_name"]
      assert_equal products.size, 24
    end

    VCR.use_cassette("search_#{term}_1_000_000") do
      refute_equal ::Openbeautyfacts::Product.search(term, page: 2).first.code, first_product.code
    end
  end

=begin
  # Test disable in order to wait for a dedicated test account to not alter real data
  def test_it_updates_product
    product_code = "3600550362626"
    product = ::Openbeautyfacts::Product.new(code: product_code)
    product_last_modified_t = nil

    VCR.use_cassette("fetch_product_#{product_code}", record: :all, match_requests_on: [:host, :path]) do
      product.fetch
      product_last_modified_t = product.last_modified_t
    end

    VCR.use_cassette("update_product_#{product_code}", record: :all, match_requests_on: [:host, :path]) do
      product.update # Empty update are accepted, allow testing without altering data.
    end

    VCR.use_cassette("refetch_product_#{product_code}", record: :all, match_requests_on: [:host, :path]) do
      product.fetch
    end

    refute_equal product_last_modified_t, product.last_modified_t
  end
=end


  # Additives

  def test_it_fetches_additives
    VCR.use_cassette("additives") do
      additives = ::Openbeautyfacts::Additive.all(locale: 'fr') # FR to have riskiness
      assert_equal "http://fr.openbeautyfacts.org/additif/e470-sels-de-sodium-potassium-calcium-d-acides-gras", additives.first.url
      refute_nil additives.detect { |additive| !additive['riskiness'].nil? }
    end
  end

  def test_it_fetches_additives_for_locale
    VCR.use_cassette("additives_locale") do
      additives = ::Openbeautyfacts::Additive.all(locale: 'fr')
      assert_equal "http://fr.openbeautyfacts.org/additif/e470-sels-de-sodium-potassium-calcium-d-acides-gras", additives.first.url
    end
  end

  def test_it_fetches_products_with_additive
    additive = ::Openbeautyfacts::Additive.new("url" => "http://world.openbeautyfacts.org/additive/e539-sodium-thiosulfate")
    VCR.use_cassette("products_with_additive") do
      products_with_additive = additive.products(page: -1)
      refute_empty products_with_additive
    end
  end

  # Brands

  def test_it_fetches_brands
    VCR.use_cassette("brands") do
      brands = ::Openbeautyfacts::Brand.all
      assert_includes brands.map { |brand| brand['name'] }, "Garnier"
    end
  end

  def test_it_fetches_brands_for_locale
    VCR.use_cassette("brands_locale") do
      brands = ::Openbeautyfacts::Brand.all(locale: 'fr')
      assert_includes brands.map { |brand| brand['name'] }, "Sedapoux"
    end
  end

  def test_it_fetches_products_for_brand
    brand = ::Openbeautyfacts::Brand.new("url" => "http://world.openbeautyfacts.org/brand/sedapoux")
    VCR.use_cassette("products_for_brand") do
      products_for_brand = brand.products(page: -1)
      refute_empty products_for_brand
    end
  end

  # Product states

  def test_it_fetches_product_states
    VCR.use_cassette("product_states") do
      product_states = ::Openbeautyfacts::ProductState.all
      assert_equal "http://world.openbeautyfacts.org/state/empty", product_states.last.url
    end
  end

  def test_it_fetches_product_states_for_locale
    VCR.use_cassette("product_states_locale") do
      product_states = ::Openbeautyfacts::ProductState.all(locale: 'fr')
      assert_equal "http://fr.openbeautyfacts.org/etat/vide", product_states.last.url
    end
  end

  def test_it_fetches_products_for_state
    product_state = ::Openbeautyfacts::ProductState.new("url" => "http://world.openbeautyfacts.org/state/photos-uploaded", "products_count" => 22)
    VCR.use_cassette("products_for_state") do
      products_for_state = product_state.products(page: -1)
      refute_empty products_for_state
    end
  end

  # FAQ

  def test_it_fetches_faq
    VCR.use_cassette("faq") do
      refute_empty ::Openbeautyfacts::Faq.items(locale: 'fr')
    end
  end

  # Press

  def test_it_fetches_press
    VCR.use_cassette("press") do
      refute_empty ::Openbeautyfacts::Press.items(locale: 'fr')
    end
  end

end
