# frozen_string_literal: true
# frozen_string_literal: true

class WikiPageController < ApplicationController
  layout 'wiki'
  before_action :set_wiki_space
  before_action :set_object, only: %i[show edit update]
  respond_to :html

  def show
    @title = @wiki_page.title
    render 'new' unless @wiki_page.id?
  end

  def edit; end

  def create
    @wiki_page = @wiki_space.wiki_pages.create(wiki_page_params.merge(user: current_user))
    respond_with(@wiki_space, @wiki_page)
  end

  def update
    @wiki_page.update(wiki_page_params.merge(user: current_user))
    respond_with(@wiki_space, @wiki_page)
  end

  private

  def path
    CGI.unescape params[:path]
  end

  def set_wiki_space
    @wiki_space = WikiSpace.find_by!(title: params[:wiki_space_id])
  end

  def set_object
    @wiki_page = @wiki_space.wiki_pages.find_or_initialize_by(path: path)
  end

  def wiki_page_params
    params.require(:wiki_page).permit(:path, :body, :title)
  end
  end
