class TagCollectionsController < ApplicationController
  before_action :set_user
  def show
  end

  def index
    @tag_collections = @user.tag_collections
  end

private

  def set_user
    @user = User.find_by_username(params[:user_id])
  end
end
