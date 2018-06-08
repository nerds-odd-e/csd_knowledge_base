# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WikiPageController, type: :controller do
  let(:page) { create :wiki_page }
  let(:space) { page.wiki_space }

  describe 'Wiki show' do
    describe 'show' do
      it 'render the layout' do
        get :show, params: { wiki_space_id: space.to_param, path: page.to_param }
        expect(response).to render_template('show', layout: 'wiki')
        expect(assigns(:wiki_page)).to eq page
        expect(assigns(:title)).to eq 'a wiki'
      end

      it 'creating non-existing page' do
        get :show, params: { wiki_space_id: space.to_param, path: 'new/id' }
        expect(assigns(:wiki_page)).to be_a_new(WikiPage)
        expect(assigns(:wiki_page).path).to eq 'new/id'
        expect(response).to render_template('new')
      end

      it 'convert path to normal text' do
        get :show, params: { wiki_space_id: space.to_param, path: 'This%20is%20a%20pen' }
        expect(assigns(:wiki_page).path).to eq 'This is a pen'
      end
    end
  end

  describe 'Wiki edit' do
    it 'find the page' do
      get :edit, params: { wiki_space_id: space.to_param, path: page.to_param }
      expect(assigns(:wiki_page)).to eq page
    end
  end

  describe 'Wiki update and create' do
    let(:user) { create :user }
    before { allow(controller).to receive(:current_user) { user } }

    it 'upate the page' do
      patch :update, params: { wiki_space_id: space.to_param, path: page.to_param, wiki_page: { body: 'blah', title: 'new name' } }
      expect(response).to redirect_to([space, page])
      page.reload
      expect(page.title).to eq 'new name'
      expect(page.current_revision.user).to eq user
      expect(WikiPageRevision.where(wiki_page: page).count).to eq 2
    end

    it 'create the page' do
      post :create, params: { wiki_space_id: space.to_param, wiki_page: { path: 'path', body: 'blah', title: 'new name' } }
      expect(assigns(:wiki_page)).to be_a(WikiPage)
      expect(assigns(:wiki_page)).to be_persisted
      expect(assigns(:wiki_page).current_revision.user).to eq user
      expect(response).to redirect_to([space, assigns(:wiki_page)])
    end
  end
end
