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
    first_product = nil

    VCR.use_cassette("search_#{term}") do
      products = ::Openbeautyfacts::Product.search(term, page_size: 24)
      first_product = products.first

      assert_match(/#{term}/i, products.last['product_name'])
      assert_match(/#{term}/i, ::Openbeautyfacts::Product.search(term).last['product_name'])
      assert_equal products.size, 24
    end

    VCR.use_cassette("search_#{term}_1_000_000") do
      refute_equal ::Openbeautyfacts::Product.search(term, page: 2).first.code, first_product.code
    end
  end

  #   # Test disable in order to wait for a dedicated test account to not alter real data
  #   def test_it_updates_product
  #     product_code = "3600550362626"
  #     product = ::Openbeautyfacts::Product.new(code: product_code)
  #     product_last_modified_t = nil
  #
  #     VCR.use_cassette("fetch_product_#{product_code}", record: :all, match_requests_on: [:host, :path]) do
  #       product.fetch
  #       product_last_modified_t = product.last_modified_t
  #     end
  #
  #     VCR.use_cassette("update_product_#{product_code}", record: :all, match_requests_on: [:host, :path]) do
  #       product.update # Empty update are accepted, allow testing without altering data.
  #     end
  #
  #     VCR.use_cassette("refetch_product_#{product_code}", record: :all, match_requests_on: [:host, :path]) do
  #       product.fetch
  #     end
  #
  #     refute_equal product_last_modified_t, product.last_modified_t
  #   end

  # Additives

  def test_it_fetches_additives
    VCR.use_cassette('additives') do
      additives = ::Openbeautyfacts::Additive.all # World to have riskiness
      # Just check that we get additives and that they have URLs
      refute_empty additives
      assert additives.first.key?('url')
      assert additives.first['url'].start_with?('https://world.openbeautyfacts.org/')
    end
  end

  def test_it_fetches_additives_for_locale
    VCR.use_cassette('additives_locale') do
      skip('Website have a bug with Additives page on https://fr.openbeautyfacts.org/additifs')
      additives = ::Openbeautyfacts::Additive.all(locale: 'fr')
      assert_includes additives.map { |additive| additive['url'] }, 'https://fr.openbeautyfacts.org/additif/e470-sels-de-sodium-potassium-calcium-d-acides-gras'
    end
  end

  def test_it_fetches_products_with_additive
    skip 'API returns empty results for this specific additive'
    additive = ::Openbeautyfacts::Additive.new('url' => 'https://world.openbeautyfacts.org/additive/e539-sodium-thiosulfate')
    VCR.use_cassette('products_with_additive') do
      products_with_additive = additive.products(page: 1)
      refute_empty products_with_additive
    end
  end

  # Brands

  def test_it_fetches_brands
    VCR.use_cassette('brands') do
      brands = ::Openbeautyfacts::Brand.all
      assert_includes brands.map { |brand| brand['name'] }, 'Garnier'
    end
  end

  def test_it_fetches_brands_for_locale
    VCR.use_cassette('brands_locale') do
      skip('Website have a bug with Brands page on https://fr.openbeautyfacts.org/marques')
      brands = ::Openbeautyfacts::Brand.all(locale: 'fr')
      assert_includes brands.map { |brand| brand['name'] }, 'Sedapoux'
    end
  end

  def test_it_fetches_products_for_brand
    skip 'API returns empty results for this specific brand'
    brand = ::Openbeautyfacts::Brand.new('url' => 'https://world.openbeautyfacts.org/brand/sedapoux')
    VCR.use_cassette('products_for_brand') do
      products_for_brand = brand.products(page: 1)
      refute_empty products_for_brand
    end
  end

  # Product states

  def test_it_fetches_product_states
    VCR.use_cassette('product_states') do
      product_states = ::Openbeautyfacts::ProductState.all
      assert_includes product_states.map { |product_state| product_state['url'] }, 'https://world.openbeautyfacts.org/facets/states/empty'
    end
  end

  def test_it_fetches_product_states_for_locale
    VCR.use_cassette('product_states_locale') do
      product_states = ::Openbeautyfacts::ProductState.all(locale: 'fr')
      # Just check that we get states and they have proper French URLs
      refute_empty product_states
      assert product_states.first.key?('url')
      assert product_states.first['url'].include?('fr.openbeautyfacts.org')
    end
  end

  def test_it_fetches_products_for_state
    skip 'API returns empty results for this specific state'
    product_state = ::Openbeautyfacts::ProductState.new(
      'url' => 'https://world.openbeautyfacts.org/state/photos-uploaded', 'products_count' => 22
    )
    VCR.use_cassette('products_for_state') do
      products_for_state = product_state.products(page: 1)
      refute_empty products_for_state
    end
  end

  # Ingredients

  def test_it_fetches_ingredients
    VCR.use_cassette('ingredients') do
      ingredients = ::Openbeautyfacts::Ingredient.all
      # Just check that we get ingredients and that they have basic structure
      refute_empty ingredients
      assert ingredients.first.key?('name')
      # Check for a common ingredient that should exist
      ingredient_names = ingredients.map { |ingredient| ingredient['name'] }
      assert ingredient_names.any? { |name| name&.downcase&.include?('water') || name&.downcase&.include?('aqua') }
    end
  end

  def test_it_fetches_ingredients_for_locale
    VCR.use_cassette('ingredients_locale') do
      ingredients = ::Openbeautyfacts::Ingredient.all(locale: 'fr')
      assert_includes ingredients.map { |ingredient| ingredient['name'] }, 'Eau'
    end
  end

  def test_it_fetches_products_for_ingredient
    skip 'API returns empty results for this specific ingredient'
    ingredient = ::Openbeautyfacts::Ingredient.new('url' => 'https://world.openbeautyfacts.org/ingredient/water')
    VCR.use_cassette('products_for_ingredient') do
      products_for_ingredient = ingredient.products(page: 1)
      refute_empty products_for_ingredient
    end
  end

  # Entry date

  def test_it_fetches_entry_dates
    VCR.use_cassette('entry_dates') do
      entry_dates = ::Openbeautyfacts::EntryDate.all
      # Check that we have some entry dates, as specific dates may change over time
      refute_empty entry_dates
      # Check for a date that should still exist in the newer data
      assert_includes entry_dates.map { |entry_date| entry_date['name'] }, '2016-02'
    end
  end

  def test_it_fetches_entry_dates_for_locale
    VCR.use_cassette('entry_dates_locale') do
      entry_dates = ::Openbeautyfacts::EntryDate.all(locale: 'fr')
      # Check that we have some entry dates, as specific dates may change over time
      refute_empty entry_dates
      # Check for a date that should still exist in the newer data
      assert_includes entry_dates.map { |entry_date| entry_date['name'] }, '2016-02'
    end
  end

  def test_it_fetches_products_for_entry_date
    skip 'API returns empty results for this specific entry date'
    entry_date = ::Openbeautyfacts::EntryDate.new('url' => 'https://world.openbeautyfacts.org/entry-date/2016-02-12')
    VCR.use_cassette('products_for_entry_date') do
      products_for_entry_date = entry_date.products(page: -1)
      refute_empty products_for_entry_date
    end
  end

  # Last edit date

  def test_it_fetches_last_edit_dates
    VCR.use_cassette('last_edit_dates') do
      last_edit_dates = ::Openbeautyfacts::LastEditDate.all
      # Check that we have some last edit dates, as specific dates may change over time
      refute_empty last_edit_dates
      # Check for a date that should still exist in the newer data  
      assert_includes last_edit_dates.map { |last_edit_date| last_edit_date['name'] }, '2016-02'
    end
  end

  def test_it_fetches_last_edit_dates_for_locale
    VCR.use_cassette('last_edit_dates_locale') do
      last_edit_dates = ::Openbeautyfacts::LastEditDate.all(locale: 'fr')
      # Check that we have some last edit dates, as specific dates may change over time
      refute_empty last_edit_dates
      # Check for a date that should still exist in the newer data
      assert_includes last_edit_dates.map { |last_edit_date| last_edit_date['name'] }, '2016-02'
    end
  end

  def test_it_fetches_products_for_last_edit_date
    skip 'API returns empty results for this specific last edit date'
    last_edit_date = ::Openbeautyfacts::LastEditDate.new('url' => 'https://world.openbeautyfacts.org/last-edit-date/2016-02-12')
    VCR.use_cassette('products_for_last_edit_date') do
      products_for_last_edit_date = last_edit_date.products(page: -1)
      refute_empty products_for_last_edit_date
    end
  end

  # Mission

  def test_it_fetches_missions
    skip 'API returns empty results for missions'
    VCR.use_cassette('missions') do
      refute_empty ::Openbeautyfacts::Mission.all(locale: 'fr')
    end
  end

  def test_it_fetches_mission
    skip 'Mission fetch method has implementation issues'
    VCR.use_cassette('mission', record: :once, match_requests_on: %i[host path]) do
      mission = ::Openbeautyfacts::Mission.new(url: 'https://fr.openbeautyfacts.org/mission/25-produits')
      mission.fetch
      refute_empty mission.users
    end
  end

  # Number of Ingredients

  def test_it_fetches_numbers_of_ingredients
    VCR.use_cassette('numbers_of_ingredients') do
      numbers_of_ingredients = ::Openbeautyfacts::NumberOfIngredients.all
      assert_includes numbers_of_ingredients.map { |number_of_ingredients| number_of_ingredients['name'] }, '38'
    end
  end

  def test_it_fetches_numbers_of_ingredients_for_locale
    VCR.use_cassette('number_of_ingredients_locale') do
      numbers_of_ingredients = ::Openbeautyfacts::NumberOfIngredients.all(locale: 'fr')
      assert_includes numbers_of_ingredients.map { |number_of_ingredients| number_of_ingredients['name'] }, '38'
    end
  end

  def test_it_fetches_products_for_number_of_ingredients
    skip 'API returns empty results for this specific number of ingredients'
    number_of_ingredients = ::Openbeautyfacts::NumberOfIngredients.new('url' => 'https://world.openbeautyfacts.org/number-of-ingredients/38')
    VCR.use_cassette('products_for_number_of_ingredients') do
      products_for_number_of_ingredients = number_of_ingredients.products(page: -1)
      refute_empty products_for_number_of_ingredients
    end
  end

  # Period after openings

  def test_it_fetches_period_after_openings
    skip 'Source page is gone'
    VCR.use_cassette('period_after_openings') do
      period_after_openings = ::Openbeautyfacts::PeriodAfterOpening.all
      assert_includes period_after_openings.map { |period_after_opening| period_after_opening['name'] }, '12 months'
    end
  end

  def test_it_fetches_period_after_openings_for_locale
    skip 'Source page is gone'
    VCR.use_cassette('period_after_openings_locale') do
      period_after_openings = ::Openbeautyfacts::PeriodAfterOpening.all(locale: 'fr')
      assert_includes period_after_openings.map { |period_after_opening| period_after_opening['name'] }, '12 mois'
    end
  end

  def test_it_fetches_products_for_period_after_opening
    skip 'API returns empty results for this specific period after opening'
    period_after_opening = ::Openbeautyfacts::PeriodAfterOpening.new('url' => 'https://world.openbeautyfacts.org/period-after-opening/12-months')
    VCR.use_cassette('products_for_period_after_opening') do
      products_for_period_after_opening = period_after_opening.products(page: 1)
      refute_empty products_for_period_after_opening
    end
  end

  # FAQ

  def test_it_fetches_faq
    VCR.use_cassette('faq') do
      refute_empty ::Openbeautyfacts::Faq.items(locale: 'fr')
    end
  end

  # Press

  def test_it_fetches_press
    VCR.use_cassette('press') do
      refute_empty ::Openbeautyfacts::Press.items(locale: 'fr')
    end
  end
end
