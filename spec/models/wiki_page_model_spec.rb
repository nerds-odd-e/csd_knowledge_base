# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WikiPage, type: :model do
  let(:user) { create :user }

  describe 'a new page' do
    subject { WikiPage.new path: 'path/to/page' }

    its(:title) { should eq 'page' }
    its(:body) { should be_nil }

    context 'when assigning title & body' do
      before { subject.wiki_space = create(:wiki_space) }
      before { subject.title = 'title' }
      before { subject.body = 'body' }
      before { subject.user = user }
      its(:title) { should eq 'title' }
      its(:body) { should eq 'body' }
      it { expect(subject.current_revision.user).to eq user }
      it { expect { subject.save! }.to change(WikiPageRevision, :count).by 1 }
    end
  end

  describe 'an existing page' do
    subject! { create :wiki_page }
    describe 'assignemnt' do
      before { subject.title = 'title' }
      before { subject.body = 'body' }
      before { subject.user = user }
      its(:title) { should eq 'title' }
      its(:body) { should eq 'body' }
      it { expect(subject.current_revision.user).to eq user }
    end

    it { expect { subject.update(user: user) }.to change { WikiPageRevision.where(wiki_page: subject).count }.to 2 }
    its(:render_body) { should be_html_safe }

    context 'creating a page with same path in another space' do
      let(:new_page) { build :wiki_page, path: subject.path }
      it { expect(new_page).to be_valid }
    end

    context 'creating a page with same path in the same space' do
      let(:new_page) { build :wiki_page, path: subject.path, wiki_space: subject.wiki_space }
      it { expect(new_page).to be_invalid }
    end

    context 'find sibling wont find in other space' do
      let(:new_page) { create :wiki_page }
      it { expect(subject.find_sibling(new_page.path)).to be_nil }
    end
  end
end
