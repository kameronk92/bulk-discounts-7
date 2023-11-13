require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:discounts) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "validations" do
    it {should validate_presence_of(:name)}
  end

  before(:each) do
    @merchant = create(:merchant, enabled: true)
    @merchant2 = create(:merchant, enabled: true)
    @merchant3 = create(:merchant)
    @merchant4 = create(:merchant)
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)
    @invoice_1 = create(:invoice, customer: @customer_1, created_at: "2023-11-07 00:04:06.477179000 +0000")
    @invoice_2 = create(:invoice, customer: @customer_2, created_at: "2020-10-02 00:04:06.477179000 +0000")
    @invoice_3 = create(:invoice, customer: @customer_3)
    @invoice_4 = create(:invoice, customer: @customer_4)
    @invoice_5 = create(:invoice, customer: @customer_5)
    @invoice_6 = create(:invoice, customer: @customer_6)
    @item_1 = create(:item, merchant: @merchant, status: "enabled", unit_price: 10000000)
    @item_2 = create(:item, merchant: @merchant, status: "enabled")
    @item_3 = create(:item, merchant: @merchant, status: "enabled")
    @item_4 = create(:item, merchant: @merchant, status: "disabled")
    @item_5 = create(:item, merchant: @merchant, status: "disabled")
    @item_6 = create(:item, merchant: @merchant, status: "disabled")
    @item_7 = create(:item, merchant: @merchant2)
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 50000, quantity: 1)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2, unit_price: 40000, quantity: 1)
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_3, unit_price: 30000, quantity: 1)
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_4, item: @item_4, unit_price: 20000, quantity: 1)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_5, item: @item_5, unit_price: 10000, quantity: 1)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_6, item: @item_6, unit_price: 6000000, status: 2, quantity: 1)
    @transaction_1 = create_list(:transaction, 5, invoice: @invoice_1, result: 0)
    @transaction_2 = create_list(:transaction, 4, invoice: @invoice_2, result: 0)
    @transaction_3 = create_list(:transaction, 3, invoice: @invoice_3, result: 0)
    @transaction_4 = create_list(:transaction, 2, invoice: @invoice_4, result: 0)
    @transaction_5 = create_list(:transaction, 1, invoice: @invoice_5, result: 0)
    @transaction_6 = create(:transaction, invoice: @invoice_6, result: 1)
  end

  describe "instance methods" do
    describe "#top_five_customers" do
      it "returns an array of customers with largest number of successful transactions for a merchant" do
        expect(@merchant.top_five_customers).to eq([@customer_1, @customer_2, @customer_3, @customer_4, @customer_5])
      end

      it "only counts successful transactions" do
        expect(@merchant.top_five_customers).to_not include(@customer_6)
      end
    end

    describe "#top_five_customers_count" do
      it "returns a hash of customers ids and transaction counts for top five customers" do
        expected = {@customer_1.id => 5, 
                  @customer_2.id => 4, 
                  @customer_3.id => 3, 
                  @customer_4.id => 2, 
                  @customer_5.id => 1}

        expect(@merchant.top_five_customers_count).to eq(expected)
      end
    end

    describe "#enabled_items" do
      it "returns an array of items whose status is enabled" do
        expect(@merchant.enabled_items.sort).to eq([@item_1, @item_2, @item_3].sort)
      end
    end

    describe "#disabled_items" do
      it "returns an array of items whose status is disabled" do
        expect(@merchant.disabled_items.sort).to eq([@item_4, @item_5, @item_6].sort)
      end
    end

    describe "#items_to_ship" do
      it "returns an array of merchant's items that are not yet shipped" do
        expected = [@item_5, @item_4, @item_3, @item_2, @item_1]
      
        expect(@merchant.items_to_ship).to eq(expected)
      end
    end

    describe "#merchant_invoices(merchant_id)" do
      it "returns a list of all items assosctiated with the merchant" do
        expected = [@invoice_1, @invoice_2, @invoice_3, @invoice_4, @invoice_5, @invoice_6]
        
        expect(@merchant.merchant_invoices(@merchant.id)).to eq(expected)
      end
    end

    describe "#merchant_items(merchant_id)" do
      it "returns list of items associated with the invoice and merchant" do
        expected = [@item_1, @item_2, @item_3, @item_4, @item_5, @item_6]
        
        expect(@merchant.merchant_items(@merchant.id)).to eq(expected)
      end
    end
    
    describe "'self.enabled_merchants" do
      it "returns an array of enabled merchant active record objects" do 
        expected = [@merchant, @merchant2]
        expect(Merchant.enabled_merchants).to eq(expected)
      end
    end

    describe "'self.disabled_merchants" do
      it "returns an array of disabled merchant active record objects" do 
        expected = [@merchant3, @merchant4]
        expect(Merchant.disabled_merchants).to eq(expected)
      end
    end
    
    describe "#top_five_items" do
      it "returns an array of 5 of a merchant's items, ordered by total revenue" do
        expected = [@item_1, @item_2, @item_3, @item_4, @item_5]
        
        expect(@merchant.top_five_items).to eq(expected)
      end
    end

    describe "'self.enabled_merchants" do
      it "returns an array of enabled merchant active record objects" do 
        expected = [@merchant, @merchant2]
        expect(Merchant.enabled_merchants).to eq(expected)
      end
    end

    describe "'self.disabled_merchants" do
      it "returns an array of disabled merchant active record objects" do 
        expected = [@merchant3, @merchant4]
        expect(Merchant.disabled_merchants).to eq(expected)
      end
    end

    describe "best_day" do
      it "returns a merchant's highest invoiced day" do

        expect(@merchant.best_day.strftime("%m/%d/%y")).to eq(@invoice_1.created_at.strftime("%m/%d/%y"))
      end
    end
  end
end
