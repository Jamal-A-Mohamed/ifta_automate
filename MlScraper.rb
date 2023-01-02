require 'selenium-webdriver'
require 'interactor'
require_relative 'motive_interactors/scraping_organizer'

class MlScraper
  def initialize
    # Initilize the driver with our desired browser
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize

    # Define search string
    #https://medium.com/wolox/web-scraping-automation-with-selenium-and-ruby-8211e4573187


    # Define global timeout threshold, when @wait is called, if the program
    # takes more than 10 secs to return something, we'll infer that somethig
    # went wrong and execution will be terminated.
    @wait = Selenium::WebDriver::Wait.new(timeout: 20) # seconds
  end

  def scrape
    # Calling interactor that orchestrates the scraper's logic
   ScrapingOrganizer.call(
      driver: @driver,
      wait: @wait
    )

    @driver.quit # Close browser when the task is completed
  end
end

# Run program
MlScraper.new.scrape
