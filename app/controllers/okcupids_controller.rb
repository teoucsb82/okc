class OkcupidsController < ApplicationController
  before_filter :authenticate_user!, :load_profile

  def authenticate
    # @profile.authenticate
    @profile.refresh_leads
  end

  def logout
    @profile.log_out
    respond_to do |format|
      format.js { render 'authenticate' }
    end
  end

  def scan
    @lead = @profile.scan_lead
  end

  private
  def load_profile
    @profile = @user.profiles.where(username: params[:username]).first
  end
end
