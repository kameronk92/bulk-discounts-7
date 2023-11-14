class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :discounts, through: :merchant

  validates :name, :description, :unit_price, :status, presence: true

  enum :status, {enabled: 0, disabled: 1}

  def format_price
    format('%.2f', (self.unit_price / 100.0)).prepend("$")
  end

  def created_format
    created_at.strftime("%A, %B %d, %Y")
  end


  def price_total
    invoice_items.sum("quantity * unit_price / 100.0")
  end
  
  def total_revenue
    invoice_items.joins(invoice: :transactions)
    .where(transactions: {result: 0})
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def top_selling_date
    date = invoices.joins(:invoice_items)
    .joins(:transactions)
    .where(transactions: {result: 0})
    .select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .group("invoices.created_at")
    .order("revenue DESC")
    .first
    .created_at
  end

  def discount
      Discount
      .select("discounts.id, MAX(discounts.percentage) AS max_discount")
      .joins(merchant: { items: :invoice_items })
      .where("invoice_items.item_id = ? AND invoice_items.quantity >= discounts.quantity", self.id)
      .group("discounts.id")  
      .order("max_discount DESC")  
      .first
  end
end