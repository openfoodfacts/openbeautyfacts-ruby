# frozen_string_literal: true

require_relative 'minitest_helper'

class TestContent < Minitest::Test
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
