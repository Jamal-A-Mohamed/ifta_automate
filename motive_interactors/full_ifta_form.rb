#https://business.gateway.ohio.gov/s/acn-bpmtransaction/a0h8y000003Km62AAC/international-fuel-tax-agreement-return


require 'selenium-webdriver'
require 'interactor'
require_relative 'ohio_login'

STATE_NAME_TO_ABBR = {
  'Alabama' => 'AL',
  'Alaska' => 'AK',
  'America Samoa' => 'AS',
  'Arizona' => 'AZ',
  'Arkansas' => 'AR',
  'California' => 'CA',
  'Colorado' => 'CO',
  'Connecticut' => 'CT',
  'Delaware' => 'DE',
  'District of Columbia' => 'DC',
  'Federated States of Micronesia' => 'FM',
  'Florida' => 'FL',
  'Georgia' => 'GA',
  'Guam' => 'GU',
  'Hawaii' => 'HI',
  'Idaho' => 'ID',
  'Illinois' => 'IL',
  'Indiana' => 'IN',
  'Iowa' => 'IA',
  'Kansas' => 'KS',
  'Kentucky' => 'KY',
  'Louisiana' => 'LA',
  'Maine' => 'ME',
  'Maryland' => 'MD',
  'Massachusetts' => 'MA',
  'Marshall Islands' => 'MH',
  'Michigan' => 'MI',
  'Minnesota' => 'MN',
  'Mississippi' => 'MS',
  'Missouri' => 'MO',
  'Montana' => 'MT',
  'Nebraska' => 'NE',
  'Nevada' => 'NV',
  'New Hampshire' => 'NH',
  'New Jersey' => 'NJ',
  'New Mexico' => 'NM',
  'New York' => 'NY',
  'North Carolina' => 'NC',
  'North Dakota' => 'ND',
  'Northern Mariana Islands' => 'MP',
  'Ohio' => 'OH',
  'Oklahoma' => 'OK',
  'Oregon' => 'OR',
  'Palau' => 'PW',
  'Pennsylvania' => 'PA',
  'Puerto Rico' => 'PR',
  'Rhode Island' => 'RI',
  'South Carolina' => 'SC',
  'South Dakota' => 'SD',
  'Tennessee' => 'TN',
  'Texas' => 'TX',
  'Utah' => 'UT',
  'Vermont' => 'VT',
  'Virgin Island' => 'VI',
  'Virginia' => 'VA',
  'Washington' => 'WA',
  'West Virginia' => 'WV',
  'Wisconsin' => 'WI',
  'Wyoming' => 'WY'
}

class FullIftaForm
  include Interactor
  def initialize(context,iftareport)
    @iftareport = iftareport
    @context = context
    @sum_gas_mileage = 0
  end
  def call
    sleep(5)

    fill_form( @context.driver,  @context.wait,@iftareport)

    sleep(10)
    #submit_form(context.driver, context.wait)
  end

  private
  attr_reader :sum_gas_mileage
  def fill_form(driver, wait,iftareport)

    selector_options =
    [
        {
            xpath: "/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[1]/p/ul/div/div[1]/li/div[2]/div/div[2]/div/div[2]/div[1]/input",
            value:200
        },
    {
        xpath:"/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[1]/p/ul/div/div[2]/li/div[3]/div/div[2]/div[1]/div[2]/div[1]/input",
        #value:@iftareport[-2].gsub(/[,]/,'').to_f
        value:200.0
    },
    {
        xpath: "/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[1]/p/ul/div/div[2]/li/div[3]/div/div[2]/div[2]/div[2]/div[1]/input",
        #value:@iftareport[-2].gsub(/[,]/,'').to_f
        value:200
    }

    ]
    sleep(5)# wait for main three fields to load.
    selector_options.each do |option|
        populate_field(driver,option[:xpath],option[:value],wait)
    end
    click_button(driver,wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[1]/p/ul/div/div[2]/li/div[2]/button')
    sleep(5) #for schedule to load

    @iftareport[0].each do |jurisdiction|
      sleep(3)
      fill_out_schedule(driver,wait,jurisdiction.split)
    end
    click_button(driver,wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/span/section/div[1]/div[2]/ul/li/button')
    sleep(4)
    populate_field(driver,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[1]/p/ul/div/div[2]/li/div[3]/div/div[2]/div[2]/div[2]/div[1]/input',sum_gas_mileage,wait)
    sleep(2)
    click_button(driver,wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[2]/p/button[3]')
    sleep(2)
    click_button(driver,wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/ul/li[2]/p/button[4]')
    sleep(15)

  end
 def fill_out_schedule(driver,wait,jurisdiction)
  if jurisdiction.size > 3
    state = STATE_NAME_TO_ABBR[jurisdiction[0]+" " + jurisdiction[1]]
    mileage = jurisdiction[2].to_s.gsub(/[,]/,'').to_f
   # gas_mileage = jurisdiction[3].to_s.gsub(/[,]/,'').to_f.round
   gas_mileage = jurisdiction[2].to_s.gsub(/[,]/,'').to_f.round
  else
    state = STATE_NAME_TO_ABBR[jurisdiction[0]]
    mileage = jurisdiction[1].to_s.gsub(/[,]/,'').to_f
    #gas_mileage = jurisdiction[2].to_s.gsub(/[,]/,'').to_f.round
    gas_mileage = jurisdiction[1].to_s.gsub(/[,]/,'').to_f.round
  end
 @sum_gas_mileage += gas_mileage

  select(driver,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/span/section/div[1]/div[2]/ul/li/div[1]/div[2]/div[1]/div/select',state,wait)
  populate_field(driver,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/span/section/div[1]/div[2]/ul/li/div[1]/div[2]/div[3]/div/input',mileage,wait)
  populate_field(driver,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/span/section/div[1]/div[2]/ul/li/div[1]/div[2]/div[5]/div/input',gas_mileage,wait)
  click_button(driver,wait,'/html/body/div[4]/div/div/div[2]/div/div/div[3]/span/section/div[1]/div[2]/ul/li/div[1]/div[2]/div[6]/button')
 end


  def click_button(driver, wait,xpath)
    puts xpath
    submit_button = wait.until do
      driver.find_element(:xpath, xpath)
    end

    submit_button.click
  end


  def populate_field(driver,xpath,value,wait)
    element = wait.until do
     driver.find_element(:xpath,xpath)
    end
    element.clear()
    element.send_keys value
  end

  def select(driver,xpath,value,wait)
    drop = wait.until do
      driver.find_element(:xpath,xpath )
    end
    choose = Selenium::WebDriver::Support::Select.new(drop)
    choose.select_by(:value, value)
  end

end
