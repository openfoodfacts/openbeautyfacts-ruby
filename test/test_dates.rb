# frozen_string_literal: true

require_relative 'minitest_helper'

class TestDates < Minitest::Test
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
end
