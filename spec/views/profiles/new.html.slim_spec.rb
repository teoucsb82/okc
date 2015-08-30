require 'spec_helper'

describe "profiles/new" do
  before(:each) do
    assign(:profile, stub_model(Profile,
      :username => "MyString",
      :password => "MyString",
      :user => nil
    ).as_new_record)
  end

  it "renders new profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", profiles_path, "post" do
      assert_select "input#profile_username[name=?]", "profile[username]"
      assert_select "input#profile_password[name=?]", "profile[password]"
      assert_select "input#profile_user[name=?]", "profile[user]"
    end
  end
end
