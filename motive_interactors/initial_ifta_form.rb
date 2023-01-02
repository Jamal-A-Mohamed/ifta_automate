#https://business.gateway.ohio.gov/s/acn-bpmtransaction/a0h8y000003Km62AAC/international-fuel-tax-agreement-return


require 'selenium-webdriver'
require 'interactor'
require 'pry'
require 'date'


class InitialIftaForm
  include Interactor

  def call
    @iftareport = EroadGetIftaReport.new(context).call
    @quarters_by_month = Hash[(1..12).map {|v| i=((v-1)/3)*3; [v,["#{Date.today.year}-#{format('%02d', i+1)}-01","#{Date.today.year}-#{format('%02d', i+3)}-30"]]}]
    #test_ifta_report

    OhioLogin.new(context).call
    click_button(context.driver, context.wait,'/html/body/div[4]/div/div/div[2]/div/div[2]/div/div[2]/div[2]/div/ul/li[1]/div/ul/li[1]/div/a')
    fill_form(context.driver, context.wait)
    click_button(context.driver, context.wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[2]/p/button[3]')

    FullIftaForm.new(context,@iftareport).call
  end

  private
  def test_ifta_report

    iftareport = @iftareport[0]
    for jurisdiction in iftareport
    end
  end

  def fill_form(driver, wait)
    fmonth,lmonth  = @quarters_by_month[6]
    renewalElement = '/html/body/div[4]/div/div/div[2]/div/div/div[3]/div[2]/div[1]/div/div[1]'
    selector_options =[
      {
          xpath: "/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[1]/p/ul/div/div/li/div[2]/div/div[2]/div[3]/div[2]/div[1]/select",
          value: "#{Date.parse(fmonth).strftime('%B')}-#{Date.parse(lmonth).strftime('%B')}"
      },
      {
      xpath:"/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[1]/p/ul/div/div/li/div[2]/div/div[2]/div[4]/div[2]/div[1]/select",
      value: "Amended"
      }]
      #detect renewal and bypass
    sleep(5)
    if driver.find_elements(:xpath,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[2]/p/button[3]').size() == 0
      puts ("renewal detected")
      click_button(driver,wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/div[2]/div[2]/div[2]/div[1]/input')
      click_button(driver,wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/div[2]/div[4]/div[2]/div[1]/input')
      click_button(driver,wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/div[3]/div/button[2]')
    end

    populate_field(driver,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[1]/p/ul/div/div/li/div[2]/div/div[2]/div[2]/div[2]/div[1]/input',Date.today.year,wait)
    selector_options.each do |option|
      select(driver,option[:xpath],option[:value])
      end
    #puts @iftareport[-1]
  end

  def click_button(driver, wait,xpath)

    submit_button = wait.until do
      driver.find_element(:xpath, xpath)
    end

    submit_button.click
  end

  def select(driver,xpath,value)
    drop = driver.find_element(:xpath,xpath )
    choose = Selenium::WebDriver::Support::Select.new(drop)
    choose.select_by(:text, value)
  end


  def populate_field(driver,xpath,value,wait)
    element = wait.until do
     driver.find_element(:xpath,xpath)
    end
    element.clear()
    element.send_keys value
  end

end
