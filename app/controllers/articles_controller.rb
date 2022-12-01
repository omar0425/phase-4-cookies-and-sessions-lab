class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end


  def show
    article = Article.find(params[:id])
    session[:page_views] ||= 0
    # 2 way of doing the same thing
    session[:page_views] = session[:page_views] + 1
    #session[:page_views] += 1
    if session[:page_views] < 4
      render json: article
    else
      render status: :unauthorized
    end
    
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
