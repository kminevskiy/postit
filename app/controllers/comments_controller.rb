class CommentsController < ApplicationController
  before_action :require_user
  before_action :set_post, only: [:create]

  def create
    @comment = Comment.new(post_params)
    @comment.post = @post
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Your comment was added"
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end

  def vote
    comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: comment, creator: current_user, vote: params[:vote])

    if @vote.valid?
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "You can only vote once."
    end

    redirect_to :back
  end

  private

  def post_params
    params.require(:comment).permit(:body)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
