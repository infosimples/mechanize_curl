# frozen_string_literal: true
##
# Raised when an an element was not found on the Page

class MechanizeCurl::ElementNotFoundError < MechanizeCurl::Error

  attr_reader :source
  attr_reader :element
  attr_reader :conditions

  def initialize source, element, conditions
    @source     = source
    @element    = element
    @conditions = conditions

    super "Element #{element} with conditions #{conditions} was not found"
  end

end

