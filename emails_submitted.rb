#!/usr/bin/env ruby

N = 10_000
puts "Downloading the last #{N} heroku logs..."
raw = `heroku logs -n 10000`.split("\n")
emails = raw.grep(/Parameters:/)
            .grep(%r{"commit"=>"Generate"})
            .map { |line| line.scan(/"email"=>"([^"]*)"/).flatten.first }
            .map { |line| line.gsub(/@c3\.com\.au\Z/i, '') }
            .map { |line| "#{line}@c3.com.au" }
            .sort.uniq

puts emails
