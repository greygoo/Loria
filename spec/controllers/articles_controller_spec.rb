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
        }.to change(Article, :count).by(0)
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
  end
end
