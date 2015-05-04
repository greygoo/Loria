class Comment < ActiveRecord::Base
  belongs_to :article
  validates :commenter, presence: true
end
