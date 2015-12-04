# https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(2) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script("jQuery.active").zero?
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end
