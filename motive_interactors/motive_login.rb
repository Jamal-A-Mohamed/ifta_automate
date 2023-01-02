
require 'selenium-webdriver'
require 'interactor'

class MotiveLogin
  include Interactor

  def call
    navigate(context.driver)
    fill_form(context.driver, context.wait)
    submit_form(context.driver, context.wait)
  end

  private

  def fill_form(driver, wait)
    # Finding search input by css selector
    username_field= wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:name, 'user[email]')
    end
    password_field = wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:name, 'user[password]')
    end
    # Writting our search_str variable to it that was defined in the initialize method of our main class
    username_field.send_keys "jamalashur@gmail.com"
    password_field.send_keys "2nJ&F4kT2$@b"
  end
  def navigate(driver)
    driver.get('https://account.gomotive.com/log-in')
  end 
  def submit_form(driver, wait)
    # Finding submit button
    submit_button = wait.until do
      driver.find_element(:id, 'sign-in-button')
    end

    # Clicking the form's submit button
    submit_button.click
  end
end