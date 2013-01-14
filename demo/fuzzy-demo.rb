# encoding: utf-8

require_relative "../lib/fuzzy-logic.rb"

temp = FuzzyLogic::Collection.new("Temperatur") { |grad|
  o = false
  if grad < 100 and grad > -100 then
    o = true
  end
  o
}

temp[:cold] = FuzzyLogic::Generate.trapezoid(-101,-100,5, 13)
temp[:hot] = FuzzyLogic::Generate.trapezoid(21,30,100,101)
temp[:warm] = FuzzyLogic::Generate.triangle(20, 11)
temp[:cool] = FuzzyLogic::Generate.triangle(10,11)

(0..30).to_a.each { |x|
  puts "#{ x } °C"
  puts temp.get(x).inspect
  puts
}
