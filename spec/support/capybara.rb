require 'capybara/rspec'
require 'selenium-webdriver'

# カスタムドライバーの定義
Capybara.register_driver :remote_chrome do |app|
  url = ENV['SELENIUM_DRIVER_URL']
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('disable-dev-shm-usage')
  options.add_argument('remote-debugging-port=9222')
  options.add_argument('window-size=1000, 800')

  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url:,
                                 capabilities: options)
end

# System Specの設定
RSpec.configure do |config|
  config.before(:each, type: :system) do
    # 定義したカスタムドライバーを使用する
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 4444
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end
