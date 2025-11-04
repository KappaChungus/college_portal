class Group < ApplicationRecord
  has_many :students, class_name: "User", foreign_key: :group_id
  has_many :courses
end
