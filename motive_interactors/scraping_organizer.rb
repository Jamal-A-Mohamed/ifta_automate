require 'selenium-webdriver'
require 'interactor'
require_relative 'motive_login'
require_relative 'ohio_login'
require_relative 'initial_ifta_form'
require_relative 'full_ifta_form'
require_relative 'pilot_login'
require_relative 'get_pilot_fuel_report'
require_relative 'eroad_login'
require_relative 'eroad_get_ifta_report'


class ScrapingOrganizer
  include Interactor::Organizer

  organize InitialIftaForm
  #organize  EroadGetIftaReport
end
