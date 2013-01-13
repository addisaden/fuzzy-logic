# encoding: utf-8

require "./fuzzy-logic.rb"

temp = FuzzyLogic::Collection.new("Temperatur") { |grad|
  o = false
  if grad < 100 and grad > -100 then
    o = true
  end
  o
}

temp[:cold] = FuzzyLogic::Generate.trapezoid(-101,-100,5, 13)
temp[:warm] = FuzzyLogic::Generate.trapezoid(13,22,100,101)
