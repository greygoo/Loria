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
 
        it "redirects to the updated article" do
          put :update, id: @article, article: FactoryGirl.attributes_for(:article)
          expect(response).to redirect_to @article
        end
      end

      context "invalid attributes" do
        it "locates the requested @article" do
          put :update, id: @article, article: FactoryGirl.attributes_for(:invalid_article)
          expect(assigns(:article)).to eq(@article)
        end

        it "does not change the @article's attributes" do
          put :update, id: @article,
            article: FactoryGirl.attributes_for(:article, title: nil, test: "Hello World again")
          @article.reload
          expect(@article.title).to eq("Testarticle updated")
          expect(@article.text).to eq("Hello World again")
        end

        it "re-renders the edit method" do
          put :update, id: @article, article: FactoryGirl.attributes_for(:invalid_article)
          expect(response).to render_template(:edit)
        end
      end
    end

    context "without authentication" do
      before :each do
        @article = FactoryGirl.create(:article, title: "Testarticle updated", text: "Hello World again")
      end

      it "does not locate the requested @article" do
        put :update, id: @article, article: FactoryGirl.attributes_for(:article)
        expect(assigns(:article)).to eq(nil)
      end

      it "responds with 401 unauthorized" do
        put :update, id: @article, article: FactoryGirl.attributes_for(:article)
        expect(response.response_code).to eq 401
      end
    end
  end

  describe "DELETE destroy" do
    context "with authentication" do
      before :each do
        admin_login
        @article = FactoryGirl.create(:article, title: "Delete me please", text: "This will be gone soon")
      end

      it "deletes the contact" do
        expect{
          delete :destroy, id: @article
        }.to change(Article, :count).by(-1)
      end

      it "redirects to articles@index" do
        delete :destroy, id: @article
        expect(response).to redirect_to articles_url 
      end
    end
  
    context "without authentication" do
      before :each do
        @article = FactoryGirl.create(:article, title: "Delete me please", text: "This will be gone soon")
      end

      it "does not delete the requested article" do
        expect{
          delete :destroy, id: @article
        }.to_not change(Article, :count)
      end

      it "responds with 401 unauthorized" do
        delete :destroy, id: @article
        expect(response.response_code).to eq 401
      end
    end
  end

  describe "DELETE destroy_all" do
    before :each do
        @article1 = FactoryGirl.create(:article, title: "Delete me please1", text: "This will be gone soon1")
        @article2 = FactoryGirl.create(:article, title: "Delete me please2", text: "This will be gone soon2")
        @article3 = FactoryGirl.create(:article, title: "Delete me please3", text: "This will be gone soon")
    end

    context "with authentication" do
      before :each do
        admin_login
      end

      it "deletes all articles" do
        expect{
          delete :destroy_all
        }.to change(Article, :count).to(0)
      end

      it "redirects to articles@index" do
        delete :destroy_all
        expect(response).to redirect_to articles_url
      end
    end

    context "without authentication" do
      it "deletes no articles" do
        expect{
          delete :destroy_all
        }.not_to change(Article, :count)

      end

      it "responses with 401 unauthorized" do
        delete :destroy_all
        expect(response.response_code).to eq 401
      end
    end


  end
end
