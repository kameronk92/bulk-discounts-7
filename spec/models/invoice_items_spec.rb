require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  describe "validations" do
    it {should validate_presence_of(:quantity)}
    it {should validate_presence_of(:unit_price)}
    it {should validate_presence_of(:status)}
  end

  describe "class methods" do
    describe "'items_to_ship" do
      it "lists items that need to be shipped" do
        @invoice_item_10 = create(:invoice_item, status: 0)
        @invoice_item_20 = create(:invoice_item, status: 1)
        @invoice_item_30 = create(:invoice_item, status: 2)

        expect(InvoiceItem.items_to_ship.first.invoice_id).to eq(@invoice_item_10.invoice_id)
        expect(InvoiceItem.items_to_ship[1].status).to eq(@invoice_item_20.status)
        expect(InvoiceItem.items_to_ship).not_to include(@invoice_item_30)
      end
    end
  end

  describe "#discount" do
    it "returns the max discount an invoice item qualifies for" do
      @invoice_8 = create(:invoice)
      @merchant_3 = create(:merchant)
      @discount_1 = @merchant_3.discounts.create(percentage: 0.25, quantity:51)
      @item_8 = create(:item, merchant: @merchant_3, unit_price: 100)
      @item_9 = create(:item, merchant: @merchant_3, unit_price: 1000)
      invoice_item_1 = @item_8.invoice_items.create(quantity: 50, unit_price: 100, invoice: @invoice_8)
      invoice_item_2 = @item_9.invoice_items.create(quantity: 100, unit_price: 1000, invoice: @invoice_8)
      @discount_2 = @merchant_3.discounts.create(percentage: 0.1, quantity:20)

      expect(@item_9.discount.id).to eq(@discount_1.id)
      expect(@item_8.discount.id).to eq(@discount_2.id)
    end
  end
end