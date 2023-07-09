#!/usr/bin/env ruby

# read list of webpages from file
webpages = File.readlines('kierunki_uam')

# iterate over each webpage
webpages.each do |webpage|
    # remove newline character
    webpage.chomp!
    # get webpage content
    puts "Getting #{webpage}..."
    puts webpage.split("/")[-1]
    `curl -s #{webpage} > kierunki_uam_html/#{webpage.split("/")[-1]}.html`
end