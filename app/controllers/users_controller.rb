class UsersController < ApplicationController
  before_action :set_user

private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by_username(params[:id])
  end
end
