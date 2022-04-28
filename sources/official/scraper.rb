#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      Name.new(
        full:     fullname,
        prefixes: ['President 2022']
      ).short
    end

    def position
      ['Member of the Swiss Federal Council',
       (fullname.start_with?('President') ? 'President of the Swiss Confederation' : [])]
    end

    def fullname
      [noko.css('a/@title').text, noko.css('a').text].reject(&:empty?).first
    end
  end

  class Members
    def members
      super.reject { |mem| mem[:name].include? 'Federal Chancellor' }
    end

    def member_container
      noko.css('.main-content .well h3')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
