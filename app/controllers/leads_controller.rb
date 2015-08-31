class LeadsController < ApplicationController
  before_filter :authenticate_user!, :load_lead

  def show
  end

  private
  def load_lead
    @profile = @user.profiles.find_by_username(params[:username])
    @lead = @profile.leads.find_by_username(params[:lead_username]) if @profile
    return redirect_to profiles_path, notice: "Sorry, could not find that match!" unless @lead
    @lead.load_full_profile
  end
end
