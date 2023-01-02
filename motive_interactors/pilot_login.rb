
require 'selenium-webdriver'
require 'interactor'

class PilotLogin
  include Interactor

  def call
    navigate(context.driver)
    fill_form(context.driver, context.wait)
    submit_form(context.driver, context.wait)
    sleep(10)
  end

  private

  def fill_form(driver, wait)
    # Finding search input by css selector
    username_field= wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:name, 'Email')
    end
    password_field = wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:name, 'Password')
    end
    # Writting our search_str variable to it that was defined in the initialize method of our main class
    username_field.send_keys "qaylo@outlook.com"
    password_field.send_keys "Rayaan1!"
  end
  def navigate(driver)
    driver.get('https://loyaltyportal.pilotflyingj.com/myrewards/login')
  end
  def submit_form(driver, wait)
    # Finding submit button
    submit_button = wait.until do
      driver.find_element(:xpath, '//*[@id="loginForm"]/div/button')
    end

    # Clicking the form's submit button
    submit_button.click
  end
end
