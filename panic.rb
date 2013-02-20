#!/usr/bin/env ruby

require_relative 'red_button'

targets = [
    #{ host: "staging-server", directory: "/var/www/example.com/staging/shared", uri: "http://staging.example.com" },
    #{ host: "another-host", directory: "/var/www/example.com/another/shared", uri: "http://another.example.com" }
  ]

button = RedButton.new(targets)
button.slam
