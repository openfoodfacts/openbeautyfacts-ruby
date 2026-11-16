# frozen_string_literal: true

require_relative 'minitest_helper'
require 'uri'

class TestFacets < Minitest::Test
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
      assert_equal 'fr.openbeautyfacts.org', URI(product_states.first['url']).host
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
      assert(ingredient_names.any? { |name| name&.downcase&.include?('water') || name&.downcase&.include?('aqua') })
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
end
