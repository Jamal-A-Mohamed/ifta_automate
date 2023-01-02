
require 'selenium-webdriver'
require 'interactor'
require 'pry'

class EroadLogin
  include Interactor

  def call
    navigate(context.driver)
    fill_form(context.driver, context.wait)
    submit_form(context.driver, context.wait)
    sleep(5)
  end

  private

  def fill_form(driver, wait)
    # Finding search input by css selector
    username_field= wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:id, 'username')
    end
    password_field = wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:id, 'password')
    end
    # Writting our search_str variable to it that was defined in the initialize method of our main class
    username_field.send_keys "dispatch@bluetiger1.com"
    password_field.send_keys "Rayaan1!"
  end
  def navigate(driver)
    driver.get('https://my.eroad.com/login')
  end

  def submit_form(driver, wait)
    # Finding submit button
    submit_button = wait.until do
      driver.find_element(:xpath, '//*[@id="root"]/section/div[2]/div[1]/section/main/div/form/div[4]/div/div/div/button')
    end

    # Clicking the form's submit button
    submit_button.click
  end
end
