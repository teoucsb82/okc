class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :leads

  def authenticate
    return true if logged_in && updated_at > 2.hours.ago
    browser = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }

    browser.post("https://www.okcupid.com/login", {
      username: username,
      password: password,
      okc_api: 1
    })

    body = JSON.parse(browser.page.body)
    success = body['screenname'] != nil
    self.update_attribute(:logged_in, success)
    return success ? browser : nil
  end

  def log_out
    self.update_attribute(:logged_in, false)
  end
end
