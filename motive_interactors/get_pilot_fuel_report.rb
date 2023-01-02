
require 'selenium-webdriver'
require 'interactor'
require_relative 'pilot_login'
require 'date'
require 'pry'
require_relative 'get_quarter'
class GetPilotFuelReport
  include Interactor

  def call
    @quarters_by_month = Hash[(1..12).map {|v| i=((v-1)/3)*3; [v,["#{Date.today.year}-#{format('%02d', i+1)}-01","#{Date.today.year}-#{format('%02d', i+3)}-30"]]}]
    PilotLogin.new(context).call
    @driver = context.driver
    @wait = context.wait
    @driver.manage.timeouts.implicit_wait = 10
    navigate
    get_mile_age
    sleep(10)
  end

  private
  def navigate
    fmonth,lmonth = @quarters_by_month[6]
    #url
    url = "https://loyaltyportal.pilotflyingj.com/myrewards/transactions#"
    @driver.get(url)
  end

  def get_mile_age
    in_quarter = true
    while in_quarter do
      transactions = @driver.find_elements(:xpath, '//tr[contains(.,"Gallons")]')
      puts transactions

      date =  process_current_page(transactions)
      if date.between?(*GetQuarter.new.call(year: 2022,quarter:3))
        @driver.find_element(:xpath,'/html/body/div[1]/div[1]/div/div[4]/div[2]/a[2]').click

      elsif  date > (GetQuarter.new.call(year: 2022,quarter:3)[0])
           @driver.find_element(:xpath,'/html/body/div[1]/div[1]/div/div[4]/div[2]/a[2]').click
       else
         in_quarter = false
       end
    end


  end

  def process_current_page(transactions)
    transactions.each do |transaction|
      transaction = (transaction.text.gsub("\n"," ").gsub("--","")).split
      return Date.strptime(transaction[0],'%m/%d/%Y')
    end
  end

end
