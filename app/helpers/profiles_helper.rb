module ProfilesHelper

  def ok_cupid_authentication
    if @profile.logged_in
      link_to "Log Out", logout_okcupid_path(username: @profile.username), class: "btn btn-primary", remote: true
    else
      link_to "Log In To OK Cupid", authenticate_okcupid_path(username: @profile.username), class: "btn btn-primary", remote: true
    end
  end
end
