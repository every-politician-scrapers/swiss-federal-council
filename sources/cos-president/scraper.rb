#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

require 'open-uri/cached'

class ExtdFrench < WikipediaDate::French
  REMAP = {
    "aujourd'hui" => ''
  }

  def remap
    super.merge(REMAP)
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Parti'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[start end name].freeze
    end

    def empty?
      false
    end

    def tds
      noko.css('td,th')
    end

    def date_class
      ExtdFrench
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
