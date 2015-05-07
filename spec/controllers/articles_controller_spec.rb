require 'rails_helper'
require 'spec_helper'
include AuthHelper

describe ArticlesController do
  describe "GET #index" do
    it "populates an array of articles" do
      article = FactoryGirl.create(:article)
      get :index
      expect(assigns(:articles)).to eq([article])
    end
 
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested article to @article" do
      article = FactoryGirl.create(:article)
      get :show, id: article
      expect(assigns(:article)).to eq(article)
    end
    
    it "renders the show view" do
      get :show, id: FactoryGirl.create(:article)
      expect(response).to render_template :show
    end
  end

  describe "POST #create" do
    context "without authentication" do
      it "does not create an article" do
        expect{
          post :create, article: FactoryGirl.attributes_for(:article)
        }.to_not change(Article, :count)
      end 

      it "responds with 401 unauthorized" do
        post :create, article: FactoryGirl.attributes_for(:article)
        expect(response.response_code).to eq 401
      end
    end

    context "with authentication" do
      before(:each) do
        admin_login
      end
  
      context "with valid attributes" do
        it "creates an article" do
          expect{
            post :create, article: FactoryGirl.attributes_for(:article)
          }.to change(Article, :count).by(1)
        end

        it "redirects to the created article" do
          post :create, article: FactoryGirl.attributes_for(:article)
          expect(response).to redirect_to Article.last
        end
      end

      context "with invalid attributes" do
        it "does not save the new article" do
          expect{
            post :create, article: FactoryGirl.attributes_for(:invalid_article)
          }.to_not change(Article,:count)
        end

        it "re-renders the new method" do
          post :create, article: FactoryGirl.attributes_for(:invalid_article)
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'PUT update' do
    context "with authentication" do
      
      before :each do
        admin_login
        @article = FactoryGirl.create(:article, title: "Testarticle updated", text: "Hello World again")
      end

      context "valid attributes" do
        it "located the requested @article" do
          put :update, id: @article, article: FactoryGirl.attributes_for(:article)
          expect(assigns(:article)).to eq(@article)
        end

        it "changes @article's attributes" do
          put :update, id: @article,
            article: FactoryGirl.attributes_for(:article, title: "Testarticle updated", text: "Hello World again")
          @article.reload
          expect(@article.title).to eq "Testarticle updated"
          expect(@article.text).to eq "Hello World again"
        end
      end
    end
  end
end
