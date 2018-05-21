class ArticlesController < ApplicationController
  before_action :set_article, only: %i[destroy edit show update]
  before_action :require_user, except: %i[index show]
  before_action :require_same_user, only: %i[destroy edit update]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = 'Article successfully created'
      redirect_to article_path(@article)
    else
      render :new
    end
  end

  def destroy
    @article.destroy
    flash[:danger] = 'Article successfully deleted'
    redirect_to articles_path
  end

  def edit; end

  def new
    @article = Article.new
  end

  def show; end

  def update
    if @article.update article_params
      flash[:success] = 'Article was successfully updated'
      redirect_to article_path(@article)
    else
      render :edit
    end

  end

  private

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def require_same_user
    unless current_user == @article.user || current_user.admin?
      flash[:danger] = 'Access denied: You can only edit or delete your own articles'
      redirect_to root_path
    end
  end

  def set_article
    @article = Article.find(params[:id])
  end

end