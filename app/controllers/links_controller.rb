class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy, :like]

  # GET /links
  def index
    if params[:tags]
      @links = Link.tagged_with(params[:tags]).order(created_at: :desc)
    else
      @links = Link.order(created_at: :desc)
    end
  end

  # GET /links/1
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_params
    params.require(:link).permit(:url, :tag_list, :private_link)
  end

  def link_create_params
    link_params.tap do |whitelist|
      whitelist[:users] = [current_user]
    end
  end
end
