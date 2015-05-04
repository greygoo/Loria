FactoryGirl.define do
  factory :comment do |f|
    f.commenter "test_commenter"
  end

  factory :invalid_comment, parent: :comment do |f|
    f.commenter nil
  end
end
