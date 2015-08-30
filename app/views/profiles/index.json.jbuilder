json.array!(@profiles) do |profile|
  json.extract! profile, :id, :username, :password, :user_id
  json.url profile_url(profile, format: :json)
end
