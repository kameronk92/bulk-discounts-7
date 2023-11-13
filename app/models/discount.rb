class Discount < ApplicationRecord
  belongs_to :merchant

  validates :percentage, :quantity, presence: true

  def pretty_percent
    "#{(self.percentage * 100).round(0)}%"
  end
end