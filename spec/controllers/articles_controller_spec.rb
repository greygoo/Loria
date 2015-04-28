require 'rails_helper'
require 'spec_helper'

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
end
