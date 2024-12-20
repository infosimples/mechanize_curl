# frozen_string_literal: true
warn 'mechanize/cookie will be deprecated.  Please migrate to the http-cookie APIs.' if $VERBOSE

require 'http/cookie'

class MechanizeCurl
  module CookieDeprecated
    def __deprecated__(to = nil)
      $VERBOSE or return
      method = caller_locations(1,1).first.base_label
      to ||= method
      case self
      when Class
        lname = name[/[^:]+$/]
        klass = 'MechanizeCurl::%s' % lname
        this = '%s.%s' % [klass, method]
        that = 'HTTP::%s.%s' % [lname, to]
      else
        lname = self.class.name[/[^:]+$/]
        klass = 'MechanizeCurl::%s' % lname
        this = '%s#%s' % [klass, method]
        that = 'HTTP::%s#%s' % [lname, to]
      end
      warn '%s: The call of %s needs to be fixed to follow the new API (%s).' % [caller_locations(2,1).first, this, that]
    end
    private :__deprecated__
  end

  module CookieCMethods
    include CookieDeprecated

    def parse(arg1, arg2, arg3 = nil, &block)
      if arg1.is_a?(URI)
        __deprecated__
        return [] if arg2.nil?
        super(arg2, arg1, { :logger => arg3 })
      else
        super
      end
    end
  end

  module CookieIMethods
    include CookieDeprecated

    def set_domain(domain)
      __deprecated__ :domain=
      @domain = domain
    end
  end

  Cookie = ::HTTP::Cookie

  class Cookie
    prepend CookieIMethods

    class << self
      prepend CookieCMethods
    end
  end
end
