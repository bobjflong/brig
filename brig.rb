#!/usr/bin/env ruby

require 'drog_lisp'
require 'drog_lisp/sexprparser'
require 'redcloth'
require 'mustache'
require 'time'

require './macros/macros'

def entry_point
  config = File.read './lisp/config.drog'

  main = File.read './lisp/main.drog'
  main = Mustache.render main, config: config
  LispPreprocessor.preprocess main, BrigMacros.macros
  
  args = {
    arg: ARGV,
    rc: RedCloth
  }

  LispMachine.run main, args
end

entry_point()
