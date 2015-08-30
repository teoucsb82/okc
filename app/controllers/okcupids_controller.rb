class OkcupidsController < ApplicationController
  before_filter :authenticate_user!, :load_profile

  def authenticate
    @browser = @profile.authenticate

    # @browser.page.body.split('{"enemy"')[-1]
  end

  def logout
    @profile.log_out
    respond_to do |format|
      format.js { render 'authenticate' }
    end
  end

  private
  def load_profile
    @profile = @user.profiles.where(username: params[:username]).first
  end
end
