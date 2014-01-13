#!/usr/bin/env ruby

require 'drog_lisp'
require 'drog_lisp/sexprparser'
require 'redcloth'

require './macros/macros'

def entry_point
  config = File.read './lisp/config.drog'
  LispMachine.run config

  main = File.read './lisp/main.drog'
  LispPreprocessor.preprocess main, BrigMacros.macros
  LispMachine.preload({
    arg: ARGV,
    rc: RedCloth
  })

  LispMachine.run main
end

entry_point()
