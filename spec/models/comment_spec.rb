require 'rails_helper'
require 'spec_helper' 

describe Comment, type: :model do
  it "has a valid factory" do
    test_comment = FactoryGirl.create(:comment)
    expect(test_comment).to be_valid
  end

  it "is invalid without a commenter" do
    article = Comment.new(commenter: nil)
    article.valid?
    expect(article.errors[:commenter]).to include("can't be blank")
  end
end
