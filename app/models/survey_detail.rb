class SurveyDetail < ApplicationRecord
  belongs_to :survey

  validates :quality_of_classes_conducted, :ease_of_communication, :fair_and_clear_conditions,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  validates :detailed_opinion, length: { maximum: 5000 }, allow_blank: true
end
