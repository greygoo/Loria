require 'rails_helper'
require 'spec_helper' 

describe Article, type: :model do
  it "has a valid factory" do
    test_article = FactoryGirl.create(:article)
    expect(test_article).to be_valid
  end

  it "is invalid without a title" do
    article = Article.new(title: nil)
    article.valid?
    expect(article.errors[:title]).to include("can't be blank")
  end

  it "is invalid with a title with less than 5 characters" do
    article = Article.new(title: "aaaa")
    article.valid?
    expect(article.errors[:title]).to include("is too short (minimum is 5 characters)")
  end
end
