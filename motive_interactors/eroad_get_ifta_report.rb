
require 'selenium-webdriver'
require 'interactor'
require 'date'

class EroadGetIftaReport
  include Interactor

  def call
    @quarters_by_month = Hash[(1..12).map {|v| i=((v-1)/3)*3; [v,["#{Date.today.year}-#{format('%02d', i+1)}-01","#{Date.today.year}-#{format('%02d', i+3)}-30"]]}]
    EroadLogin.new(context).call
    navigate(context.driver)
    get_mile_age(context.driver,context.wait)
  end

  private
  def navigate(driver)
    fmonth,lmonth = @quarters_by_month[6]
    #url
    url = "https://my.eroad.com/Portal/report/fleetsummary/areadistancesummary"
    driver.get(url)
  end
  def get_mile_age(driver, wait)
    selector_options =[
      {
          xpath: "//*[@id='timespan']",
          value: "Quarterly"
      }]
      sleep(5)
      driver.switch_to.frame(0)
      selector_options.each do |option|
        select(driver,option[:xpath],option[:value])
        end
      #binding.pry
      set_quarter(driver,wait)
    data = wait.until do
      driver.find_element(:id,'areaDistanceList')
    end
    [data.text.gsub(/\(([^\)]+)\)\n/,'').split("\n")]
  end

  def select(driver,xpath,value)
    # binding.pry
    drop = driver.find_element(:xpath,xpath )
    choose = Selenium::WebDriver::Support::Select.new(drop)
    choose.select_by(:text, value)
  end

  def set_quarter(driver,wait)
    button =  driver.find_element(:xpath,'//*[@id="previousLink"]')
    quarter = driver.find_element(:xpath,'//*[@id="reportdatesheadingtext"]').text.split(',')[0]
    submittedQuarter = 'Q3'
    if quarter == submittedQuarter
      button.click
    end
  end

end
