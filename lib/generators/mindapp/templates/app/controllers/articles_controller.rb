class ArticlesController < ApplicationController
  before_action :load_article, only: [:show, :destroy]
  before_action :load_comments, only: :show

	def index
    @articles = Article.desc(:created_at).page(params[:page]).per(10)
	end

  def show; end

  def create
    @article = Article.new(
                      title: $xvars["form_article"]["title"],
                      text: $xvars["form_article"]["text"],
                      body: $xvars["form_article"]["body"],

                      user_id: $xvars["user_id"])
    @article.save!
  end

  def my
    @articles = Article.where(user_id: current_user).desc(:created_at).page(params[:page]).per(10)
  end

  def update
    # $xvars["select_article"] and $xvars["edit_article"]
    # These are variables.
    # They contain everything that we get their forms select_article and edit_article
    @article = Article.find($xvars["select_article"]["title"])
    @article.update(title: $xvars["edit_article"]["title"],
                    text: $xvars["edit_article"]["text"])
  end

  def destroy
    if current_user.role.upcase.split(',').include?("A") || current_user == @article.user
      @article.destroy
    end
      redirect_to :action=>'index'
  end

  private

  def load_article
    @article = Article.find(params[:id])
  end

  def load_comments
    @comments = @article.comments.find_all
  end

end
