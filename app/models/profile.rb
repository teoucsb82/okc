class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :leads, dependent: :destroy

  def authenticate
    browser = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }

    browser.post("https://www.okcupid.com/login", {
      username: username,
      password: password,
      okc_api: 1
    })

    body = JSON.parse(browser.page.body)
    success = body['screenname'] != nil
    self.update_attribute(:logged_in, success)
    return nil unless success
    return browser
  end

  def refresh_leads
    browser = authenticate
    html = Nokogiri::HTML(browser.get("https://www.okcupid.com/home").body)
    html.css("li.item a.name").each do |profile| 
      lead = Lead.create_or_update({ username: profile.text, profile_id: self.id })
    end
  end

  def scan_lead
    possible_leads = self.leads.last.similar_profiles  
    existing_leads = self.leads.pluck(&:username)

    u = (possible_leads - existing_leads).sample
    Lead.create_or_update({ username: u, profile_id: self.id })
  end

  def fetch_leads(browser = nil)
    return unless browser # Logs into the landing page and grabs any visible results

    browser.get("http://www.okcupid.com/match")
    browser.page.body.split('{"enemy"').each_with_index do |profile, i|
      next if i == 0 #skip the first blob of html
      begin
        str = '{"enemy"' + profile.gsub!(']}, ', ']}')
      rescue
        # for last blob of html, split out junk after results
        str = '{"enemy"' + profile.split(']}], ').first + "]}"
      end
      str.gsub!(" : ", " => ")
      begin
        attributes = eval(str)
        Lead.create_or_update({ username: attributes["username"], profile_id: self.id })
      rescue
      end
    end
  end

  def log_out
    self.update_attribute(:logged_in, false)
  end
end
