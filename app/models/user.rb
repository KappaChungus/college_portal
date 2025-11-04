class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  self.inheritance_column = :type
  validates :name, presence: true
  belongs_to :group, optional: true
end
