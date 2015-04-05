class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy, :like]
  before_action :set_user, only: [:index]

  # GET /links
  def index
    @links = Link.order(created_at: :desc).visible_for(current_user)
    @links = @links.tagged_with(params[:tags]) if params[:tags].present?
    @links = @links.for_user(@user) if @user
  end

  # GET /links/1
  def show
  end

  # GET /links/new
  def new
    @link = Link.new(url: params[:url])
    @link.fetch_from_embedly
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  def create
    @link = Link.new(link_create_params)

    if @link.unique?
      if @link.save
        redirect_to edit_link_path(@link), notice: 'Link was successfully created.', class: 'well'
      else
        render :new
      end
    elsif existing_link = @link.merge_with_existing
      redirect_to edit_link_path(existing_link), notice: 'Link already exists.', class: 'well'
    else
      render :new
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    if @link.update(link_params)
      redirect_to link_path(@link), notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    redirect_to root_url, notice: 'Link was successfully destroyed.'
  end

  def like
    current_user.like(@link)

    respond_to do |format|
      format.js
    end
  end

  def external_link
    render :layout => "external"
    external_url= [params[:link]]
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:id])
  end

  def set_user
    @user = User.find_by_username(params[:user_id]) if params[:user_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_params
    params.require(:link).permit(:tag_list, bookmarks_attributes: [:id, :private])
  end

  def link_create_params
    params.require(:link).permit(:tag_list, :url, :title, :description, :favicon_url, :provider_name, :provider_url, :media_type, :html, :thumbnail_url, bookmarks_attributes: [:id, :private]).tap do |whitelist|
      whitelist[:users] = [current_user]
    end
  end
end
