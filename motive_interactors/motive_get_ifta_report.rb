
require 'selenium-webdriver'
require 'interactor'
require_relative 'motive_login'
require 'date'

class MotiveGetIftaReport
  include Interactor

  def call
    @quarters_by_month = Hash[(1..12).map {|v| i=((v-1)/3)*3; [v,["#{Date.today.year}-#{format('%02d', i+1)}-01","#{Date.today.year}-#{format('%02d', i+3)}-30"]]}]
    MotiveLogin.new(context).call
    navigate(context.driver)
    sleep(10)
    get_mile_age(context.driver,context.wait)

  end

  private
  def navigate(driver)
    fmonth,lmonth = @quarters_by_month[6]
    #url
    url = "https://app.gomotive.com/en-US/#/reports/ifta-distance/fleet;start_date=#{fmonth};end_date=#{lmonth};sort_field=total_fuel;sort_direction=asc;report_id=25;report_type=normal"
    driver.get(url)
  end
  def get_mile_age(driver, wait)
    # Finding search input by css selector
    total_distance = wait.until do # Wait was defd in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:xpath, '/html/body/kt-app/div[2]/div[2]/reports/dynamic-report/div/div[2]/summary/table-summary/div/div[1]/span[1]')
    end
    total_fuel = wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:xpath, '/html/body/kt-app/div[2]/div[2]/reports/dynamic-report/div/div[2]/summary/table-summary/div/div[2]/span[1]')
    end
    data = wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
        driver.find_element(:xpath, '/html/body/kt-app/div[2]/div[2]/reports/dynamic-report/div/reports-table/nz-table/nz-spin/div/div/div/div/cdk-virtual-scroll-viewport/div[1]/table')
      end
  [data.text.lines(),total_distance.text,total_fuel.text]
  end
end
