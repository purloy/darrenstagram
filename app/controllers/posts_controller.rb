class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only:[:new, :edit]


  def index
   @posts = Post.all.order("created_at asc").paginate(:page => params[:page], :per_page => 2)
  end

  def new
    @post = current_user.posts.build
  
  end

  def show
    @comment = Comment.new

    if @post.comments.blank?
      @average_review = 0
    else
      @average_review = @post.comments.average(:rating).round(2)
    end

  end

  def edit

  end

  def update
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post
    else
      render 'new'
    end

  end

  def destroy
    @post.destroy
    redirect_to  posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:image, :description)
  end


end
