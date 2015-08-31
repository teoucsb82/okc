class Lead < ActiveRecord::Base
  belongs_to :profile

  attr_accessor :enemy, :relative, :gender
  attr_accessor :location, :distance
  attr_accessor :userid, :match, :gender_tags, :orientation
  attr_accessor :photo, :thumbnail
  attr_accessor :age
  attr_accessor :essays, :looking_for, :details
  attr_accessor :similar_profiles

  after_initialize :load_data

  def self.create_or_update(params)
    user = params[:username]
    attributes = {}
    attributes["profile"] = {}

    lead = Lead.where(username: user, profile_id: params[:profile_id]).first
    if lead
      lead.update_attribute(:data, attributes.except(:profile_id).to_json)
    else
      lead = Lead.create(profile_id: params[:profile_id], username: user, data: attributes.to_json)
      lead.load_full_profile
    end
    lead.load_data
    lead
  end

  def lookup(name)
  end

  def load_full_profile
    return if self.essays
    browser = self.profile.authenticate
    full_profile = Lead.scan_profile(browser.get("https://www.okcupid.com/profile/#{username}").body)
    puts "sleeping 1"
    sleep(1)
    existing_json = data ? JSON.parse(self.data) : {}
    existing_json.merge!(full_profile)
    self.update_attribute(:data, existing_json.to_json)
  end

  def load_data
    json = self.data ? JSON.parse(self.data) : {}

    self.enemy           ||= json["enemy"]
    # self.relative        ||= json["relative"]
    # self.gender          ||= json["gender"]
    self.location           ||= json["location"]
    self.distance           ||= json["distance"]
    # self.userid          ||= json["userid"]
    self.match           ||= json["match"]
    # self.gender_tags     ||= json["gender_tags"]
    # self.orientation     ||= json["orientation"]
    self.similar_profiles     ||= json["similar_profiles"]
    self.photo           ||= json["thumbnails"].first if json["thumbnails"]
    self.thumbnail       ||= json["thumbnails"].first if json["thumbnails"]
    self.age             ||= json["age"]
    self.essays          ||= json["essays"]
    self.looking_for     ||= json["looking_for"] 
    self.details         ||= json["details"] 
    self.update_attribute(:liked, json["liked"])
  end

  def self.scan_profile(body)
    html = Nokogiri::HTML(body)
    results = {}
    
    results["thumbnails"] = html.css("#profile_thumbs .thumb img").map(&:first).map(&:last)
    results["match"] = html.css(".match .percent").text.strip
    results["enemy"] = html.css(".enemy .percent").text.strip
    results["age"] = html.css("#ajax_age").text.strip
    results["location"] = html.css("#ajax_location").text.strip
    results["distance"] = html.css(".dist").text.strip

    p = []
    html.css("#similar_users_list a").each do |similar_profile|
      p << similar_profile.attributes["href"].to_s.split("profile/").last.split("?").first if similar_profile.attributes
    end
    results["similar_profiles"] = p 

    results["looking_for"] = {}
    results["looking_for"]["gentation"] = html.css("#ajax_gentation").children.text.strip
    results["looking_for"]["ages"] = html.css("#ajax_ages").children.text.strip
    results["looking_for"]["near"] = html.css("#ajax_near").children.text.strip
    results["looking_for"]["single"] = html.css("#ajax_single").children.text.strip
    results["looking_for"]["for"] = html.css("#ajax_lookingfor").children.text.strip

    results["details"] = {}
    results["details"]["last_online"] = html.css("#profile_details dd").first.text.strip.split("if (FancyDate)").first
    results["details"]["orientation"] = html.css("#ajax_orientation").children.text.strip
    results["details"]["ethnicities"] = html.css("#ajax_ethnicities").children.text.strip
    results["details"]["height"] = html.css("#ajax_height").children.text.strip
    results["details"]["bodytype"] = html.css("#ajax_bodytype").children.text.strip
    results["details"]["diet"] = html.css("#ajax_diet").children.text.strip
    results["details"]["drinking"] = html.css("#ajax_drinking").children.text.strip
    results["details"]["drugs"] = html.css("#ajax_drugs").children.text.strip
    results["details"]["religion"] = html.css("#ajax_religion").children.text.strip
    results["details"]["sign"] = html.css("#ajax_sign").children.text.strip
    results["details"]["education"] = html.css("#ajax_education").children.text.strip
    results["details"]["job"] = html.css("#ajax_job").children.text.strip
    results["details"]["monogamous"] = html.css("#ajax_monogamous").children.text.strip
    results["details"]["children"] = html.css("#ajax_children").children.text.strip
    results["details"]["pets"] = html.css("#ajax_pets").children.text.strip
    results["details"]["languages"] = html.css("#ajax_languages").children.text.strip

    results["essays"] = {}
    results["essays"]["essay_0"] = { title: html.css("#essay_0 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_0").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_1"] = { title: html.css("#essay_1 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_1").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_2"] = { title: html.css("#essay_2 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_2").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_3"] = { title: html.css("#essay_3 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_3").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_4"] = { title: html.css("#essay_4 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_4").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_5"] = { title: html.css("#essay_5 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_5").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_6"] = { title: html.css("#essay_6 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_6").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_7"] = { title: html.css("#essay_7 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_7").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_8"] = { title: html.css("#essay_8 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_8").children.text.strip.gsub("\n", " ")}
    results["essays"]["essay_9"] = { title: html.css("#essay_9 .essay_title").children.text.strip,
                                     text:  html.css("#essay_text_9").children.text.strip.gsub("\n", " ")}
    results
  end
end
