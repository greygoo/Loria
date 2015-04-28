FactoryGirl.define do
  factory :article do |f|
    f.title "Hello World"
  end

  factory :invalid_article, parent: :contact do |f|
    f.title nil
  end
end
