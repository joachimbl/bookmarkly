class CommentsController < ApplicationController
  before_action :set_link

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to @link
    else
      raise @comment.errors.inspect
      # redirect_to @link
    end
  end

private

  def set_link
    @link = Link.find(params[:link_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id).tap do |whitelist|
      whitelist[:user] = current_user
      whitelist[:link] = @link
    end
  end
end
