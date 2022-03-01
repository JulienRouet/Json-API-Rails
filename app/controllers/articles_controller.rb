class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  # GET /articles
  def index
    @articles = if user_signed_in?
                  Article.where(private: false) + private_articles
                else
                  Article.where(private: false)
                end

    render json: @articles
  end

  # GET /articles/1
  def show
    if @article.private == true && @article.user != current_user
      render json: { 'error': "can't view private article that you do not own" }
    else
      render json: @article
    end
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    @article.update(user: current_user)

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.user != current_user
      render json: { 'error': "can't edit article that you do not own" }
    elsif @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    if @article.user != current_user
      render json: { 'error': "can't delete article that you do not own" }
    else
      @article.destroy
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :content, :private)
  end

  def private_articles
    Article.where(private: true).where(user_id: current_user.id)
  end
end