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
    self.invoice_items.sum("quantity * unit_price")
  end

  def bulk_discount(merchant)
    Invoice.where(id: self.id)
        .joins(invoice_items: { item: :discounts })
        .where(items: { merchant_id: merchant.id })
        .where(discounts: { merchant_id: merchant.id })
        .where("invoice_items.quantity >= discounts.quantity")
        .sum("invoice_items.quantity * invoice_items.unit_price * discounts.percentage")
  end
end
