#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygems"
require "bundler/setup"

#require 'rest_client'
require 'json'
require 'open-uri'
require 'nokogiri'

if !File.directory?('data')
	Dir.mkdir 'data'
end

span = Date.new(2000, 1, 1)..Date.new(2000, 12, 31)
span.each { |x| 
  actual_date = x.strftime("%m-%d")
  wiki_date = x.strftime("%B %e").gsub(/ +/, ' ')

  puts wiki_date

  cat = ""
  data = {
  }

  url = "https://en.wikipedia.org/wiki/#{x.strftime('%B')}_#{x.strftime('%e').strip}"
  puts url
  wikitext = open(url) do |f|
    f.read
  end
  File.open("data/#{actual_date}.html", 'w') {|f| f.write(wikitext) }


  # switch to regular dashes
  wikitext.gsub!(/–/, "-")
  
  doc = Nokogiri::HTML(wikitext)
  ["Events", "Births", "Deaths"].each do |key|
    data[key] ||= []
    
    head = doc.css("span##{key}").first.parent

    list = head.next_element
    list.css("li").each do |item|
      # get the flat text of the entry
      text = item.text
      puts text
      
      # 153 BC – Roman consuls begin their year in office.
      
      # figure out the year of the event
      year, result = text.split(" - ", 2)
      #puts item.inspect
      
      # remove the first link if it happens to be the year
      maybe_year = item.css("a").first
      if maybe_year && maybe_year.content == year
        maybe_year.remove
      end

      item.css("a").each { |link|
        link["href"] = "https://wikipedia.org#{link['href']}"
      }
      
      links = item.css("a").collect { |link|
        if link.attributes['title']
          {
            title: link.attributes['title'].value,
            link: link['href']
          }
        else
          nil
        end
      }.compact

      data[key] << {
        year: year,
        text: result,
        html: item.inner_html.gsub(/^#{year.to_i} ?- /, "").gsub(/^ - /, ""),
        links: links       
      }
    end
  end

  results = {
    :date => wiki_date,
    :url => "https://wikipedia.org/wiki/#{wiki_date.gsub(/ /, '_')}",
    :data => data
  }
  File.open("data/#{actual_date}.json", 'w') {|f| f.write(results.to_json) }
} # span.each
