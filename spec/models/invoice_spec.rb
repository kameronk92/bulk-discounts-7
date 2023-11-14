require "rails_helper"

RSpec.describe Invoice, type: :model do
  before :each do
    @date = DateTime.new(2012, 3, 10)
    @invoice1 = create(:invoice, created_at: @date) # automatically create associated customer, transactions and invoice_items
  end
  describe "relationships" do
    it { should have_many(:invoice_items) }
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it {should validate_presence_of :status}
  end

  describe "instance methods" do
    describe "#date_format" do
      it "can return the created_at date formatted as 'day_of_week, full_month padded_day, year'" do
        expect(@invoice1.date_format).to eq("Saturday, March 10, 2012")
      end
    end

    describe "#total_revenue" do
      it "can find the total revenue on an invoice" do
        item1 = create(:item, unit_price: 100)
        item2 = create(:item, unit_price: 200)
        create(:invoice_item, invoice: @invoice1, item: item1, quantity: 2, unit_price: 100)
        create(:invoice_item, invoice: @invoice1, item: item2, quantity: 3, unit_price: 200)

        expect(@invoice1.total_revenue).to eq(8)
      end
    end
  end
end