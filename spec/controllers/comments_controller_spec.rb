require 'rails_helper'
require 'spec_helper'
include AuthHelper

describe CommentsController do
  describe "POST #create" do
    before :each do
      @article = FactoryGirl.create(:article)
    end

    context "with valid attributes" do
      it "creates an comment" do
        expect{
          post :create, article_id: @article, comment: FactoryGirl.attributes_for(:comment)
        }.to change(Comment, :count).by(1) 
      end

      it "redirects to article" do
        post :create, article_id: @article, comment: FactoryGirl.attributes_for(:comment)
        expect(response).to redirect_to(@article) 
      end
    end

    context "with invalid attributes" do
      it "does not create a comment" do
        expect{
          post :create, article_id: @article, comment: FactoryGirl.attributes_for(:invalid_comment)
        }.not_to change(Comment, :count)
      end  

      it "redirects to article" do
        post :create, article_id: @article, comment: FactoryGirl.attributes_for(:comment)
        expect(response).to redirect_to(@article)
      end
    end
  end

  describe "DELETE destroy" do

  end
end
