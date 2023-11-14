class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer
  has_many :discounts, through: :items

  validates :status, presence: true

  enum :status, {"in progress": 0, "completed": 1, "cancelled": 2}

  def date_format
    self.created_at.strftime("%A, %B %d, %Y")
  end

  def total_revenue
    self.invoice_items.sum("quantity * unit_price / 100")
  end

  def bulk_discount
    invoice_items
        .select("invoice_items.id, (discounts.percentage) * (invoice_items.quantity * invoice_items.unit_price / 100.0) AS item_discount")
        .joins(item: { merchant: :discounts })
        .where("invoice_items.quantity >= discounts.quantity")
        .sum(&:item_discount)
  end
end
