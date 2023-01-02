
require 'selenium-webdriver'
require 'interactor'

class OhioLogin
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
      driver.find_element(:id, 'loginUserID')
    end
    password_field = wait.until do # Wait was defined in the initalize method of the main class, if it takes more than 10s to find the element, something went wrong
      driver.find_element(:id, 'loginPassword')
    end
    # Writting our search_str variable to it that was defined in the initialize method of our main class
    username_field.send_keys "dantac0563"
    password_field.send_keys "OBGdan18$"
  end
  def navigate(driver)
    driver.get('https://ohid.ohio.gov/wps/portal/gov/ohid/login')
  end

  def submit_form(driver, wait)
    # Finding submit button
    submit_button = wait.until do
      driver.find_element(:name, 'submitUser')
    end

    # Clicking the form's submit button
    submit_button.click
    navigate_to_app(driver,wait)

  end

  def navigate_to_app(driver,wait)
    submit_button = wait.until do
        driver.find_element(:xpath, '/html/body/div[3]/section/div[4]/div/div/div/div[2]/div/div[1]/div/div/div/div[2]/div[2]/div[2]/div/div/main/article/div/div/div[2]/div[2]/div[4]/div/div/div/div/div[3]/div[2]/a')
      end

      # Clicking the form's submit button
      submit_button.click
      driver.switch_to.window(driver.window_handles[1])
  end

end
