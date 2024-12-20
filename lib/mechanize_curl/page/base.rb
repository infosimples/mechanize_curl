# frozen_string_literal: true
##
# A base element on an HTML page.  Mechanize treats base tags just like 'a'
# tags.  Base objects will contain links, but most likely will have no text.

class MechanizeCurl::Page::Base < MechanizeCurl::Page::Link
end

