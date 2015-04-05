class TagCollectionsController < ApplicationController
  before_action :set_user, only: [:index]
  def show
  end

  def index
    @tag_collections = @user.tag_collections
  end

  def create
    @tag_collection = TagCollection.create(tag_collection_create_params)

    redirect_to links_path(tags: @tag_collection.tag_list_string), notice: 'You are now following this collection.', class: 'well'
  end

  def destroy
    @tag_collection = TagCollection.find(params[:id])
    tag_list = @tag_collection.tag_list_string

    @tag_collection.destroy
    redirect_to links_path(tags: tag_list), notice: 'You no longer follow this collection.', class: 'well'
  end


private

  def tag_collection_params
    params.require(:tag_collection).permit(:tag_list)
  end

  def tag_collection_create_params
    tag_collection_params.tap do |whitelist|
      whitelist[:users] = [current_user]
    end
  end

  def set_user
    @user = User.find_by_username(params[:user_id])
  end
end
