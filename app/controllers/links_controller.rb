class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy, :like, :add, :remove]

  # GET /links
  def index
    @scoped_user = User.find_by_username(params[:user_id]) if params[:user_id]
    @tag_collection = current_user.tag_collections.tagged_with(params[:tags], match_all: true).first if user_signed_in?
    @tag_collection ||= TagCollection.new(tag_list: params[:tags])

    @links = policy_scope(Link).order(created_at: :desc)
    @links = @links.tagged_with(params[:tags]) if params[:tags].present?
    @links = @links.for_user(@scoped_user) if @scoped_user
    @links = @links.page(page).per(per)
  end

  # GET /links/1
  def show
    authorize @link
  end

  # GET /links/new
  def new
    @link = Link.new(url: params[:url])

    if @link.unique?
      authorize @link
      @link.fetch_from_embedly
    else
      existing_link = @link.merge_with_existing
      redirect_to link_path(existing_link), notice: 'Link already exists.', class: 'well'
    end
  end

  # GET /links/1/edit
  def edit
    authorize @link
  end

  # POST /links
  def create
    @link = Link.new(link_create_params)
    authorize @link

    if @link.unique?
      if @link.save
        redirect_to link_path(@link), notice: 'Link was successfully created.', class: 'well'
      else
        render :new
      end
    elsif existing_link = @link.merge_with_existing
      redirect_to link_path(existing_link), notice: 'Link already exists.', class: 'well'
    else
      render :new
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    authorize @link
    if @link.update(link_update_params)
      redirect_to link_path(@link), notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  def add
    authorize @link
    @link.users << current_user

    redirect_to @link, notice: 'Link was added to your collections.'
  end

  def remove
    authorize @link
    @link.users.delete(current_user)
    if @link.destroy_if_ownerless
      redirect_to links_path, notice: 'Link was deleted.'
    else
      redirect_to @link, notice: 'Link was removed from your collections.'
    end
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
  def page
    params[:page] || 1
  end

  def per
    params[:per] || 24
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:provider], params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_update_params
    params.require(:link).permit(:tag_list, bookmarks_attributes: [:id, :private])
  end

  def link_create_params
    params.require(:link).permit(:tag_list, :url, :title, :description, :favicon_url, :provider_name, :provider_url, :media_type, :html, :thumbnail_url, bookmarks_attributes: [:id, :private]).tap do |whitelist|
      whitelist[:users] = [current_user]
    end
  end
end
