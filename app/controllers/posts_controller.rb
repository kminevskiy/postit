class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_creator, only: [:edit, :update]

  def index
    @posts = Post.limit(Post::PER_PAGE).offset(params[:offset])
    @pages = (Post.all.size / Post::PER_PAGE.to_f).ceil
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post was created"
      redirect_to posts_path
    else
      @errors = @post.errors.full_messages
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "The post was updated"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You can only vote for a post once."
        end
        redirect_back(fallback_location(root_path))
      end
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def is_creator_or_admin?
    logged_in? && (current_user.admin? || @post.creator == current_user)
  end

  def require_creator
    access_denied unless logged_in? && (current_user.admin? || @post.creator == current_user)
  end
end
