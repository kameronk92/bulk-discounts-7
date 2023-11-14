class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :quantity, :unit_price, :status, presence: true
  
  enum :status, {pending: 0, packaged: 1, shipped: 2}

  def self.items_to_ship
    joins(:invoice)
    .where.not(status: 2)
    .select('id', 'invoices.id as invoice_id', 'invoice_items.status', 'invoices.created_at')
    .order('invoices.created_at ASC')
  end
end
