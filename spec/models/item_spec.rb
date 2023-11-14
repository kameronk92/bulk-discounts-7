require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:unit_price)}
    it {should validate_presence_of(:description)}
  end

  before(:each) do
    @merchant = create(:merchant)
    @item_1 = create(:item, unit_price: 1_234, merchant: @merchant)
    @invoice_1 = create(:invoice)
    @customer_1 = create(:customer)
    @invoice_1 = create(:invoice, customer: @customer_1, created_at: "2023-11-07 00:04:06.477179000 +0000")
    @invoice_2 = create(:invoice, customer: @customer_1, created_at: "2000-01-01 00:04:06.477179000 +0000")
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 50_000, quantity: 9)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_1, unit_price: 50_000, quantity: 1)
    @transaction_1 = create_list(:transaction, 5, invoice: @invoice_1, result: 0)
    @transaction_1 = create_list(:transaction, 5, invoice: @invoice_2, result: 0)
  end

  describe "instance methods" do
    describe "#format_price" do
      it "returns unit price formatted as dollars and cents" do
        expect(@item_1.format_price).to eq("$12.34")
      end
    end

    describe "#created_format" do
      it "returns created date formated as weekday, month day, year" do
        time = Time.new.in_time_zone("UTC")
      
        expect(@item_1.created_format).to eq(time.strftime("%A, %B %d, %Y"))
      end
    end

    describe "#price_total" do

      it "gives the sum of the quantity and cost" do
        expect(@item_1.price_total).to eq(5000)
      end
      
      it "gives the sum of the invoice items quantity and cost" do
        expect(@item_1.price_total).to eq(5000)
      end
    end

    describe "#total_revenue" do
      it "returns the total revenue from completed tranactions for an item" do
        expect(@item_1.total_revenue).to eq(2_500_000)
      end
    end

    describe "#top_selling_date" do
      it "returns the date with the most sales for an item" do
        expect(@item_1.top_selling_date).to eq("2023-11-07 00:04:06.477179000 +0000")
      end
    end
  end
end