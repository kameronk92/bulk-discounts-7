require "rails_helper"

RSpec.describe "merchant invoice show page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @invoice_1 = create(:invoice)
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)
    @customer_7 = create(:customer)
    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice, customer: @customer_2)
    @invoice_3 = create(:invoice, customer: @customer_3)
    @invoice_4 = create(:invoice, customer: @customer_4)
    @invoice_5 = create(:invoice, customer: @customer_5)
    @invoice_6 = create(:invoice, customer: @customer_6)
    @invoice_7 = create(:invoice, customer: @customer_7)
    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)
    @item_4 = create(:item, merchant: @merchant_1)
    @item_5 = create(:item, merchant: @merchant_1)
    @item_6 = create(:item, merchant: @merchant_1)
    @item_7 = create(:item, merchant: @merchant_2)
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 50_000, quantity: 2)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2)
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_3)
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_4, item: @item_4)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_5, item: @item_5)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_6, item: @item_6, status: 2)
    @invoice_item_7 = create(:invoice_item, invoice: @invoice_7, item: @item_7)
    @transaction_1 = create_list(:transaction, 5, invoice: @invoice_1, result: 0)
    @transaction_2 = create_list(:transaction, 4, invoice: @invoice_2, result: 0)
    @transaction_3 = create_list(:transaction, 3, invoice: @invoice_3, result: 0)
    @transaction_4 = create_list(:transaction, 2, invoice: @invoice_4, result: 0)
    @transaction_5 = create_list(:transaction, 1, invoice: @invoice_5, result: 0)
    @transaction_6 = create(:transaction, invoice: @invoice_6, result: 1)


    #bulk discount data: 
    @invoice_8 = create(:invoice)
    @merchant_3 = create(:merchant)
    @discount_1 = @merchant_3.discounts.create(percentage: 0.25, quantity:51)
    @discount_2 = @merchant_3.discounts.create(percentage: 0.50, quantity:101)
    @item_8 = create(:item, merchant: @merchant_3, unit_price: 100)
    @item_9 = create(:item, merchant: @merchant_3, unit_price: 1000)
    invoice_item_1 = @item_8.invoice_items.create(quantity: 50, unit_price: 100, invoice: @invoice_8)
    invoice_item_2 = @item_9.invoice_items.create(quantity: 100, unit_price: 1000, invoice: @invoice_8)
  end

  #US 15
  describe "Merchant Invoice Show Page" do
    it "Shows invoice information" do
      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.date_format)
      expect(page).to have_content(@invoice_1.customer.first_name)
      expect(page).to have_content(@invoice_1.customer.last_name)
    end
  end

  #US 16
  describe "Merchant Invoice Show Page: Invoice Item Information" do
    it "shows items on the invoice related to the merchent" do
      visit"/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to_not have_content(@item_7.name)
    end

    it "Shows total revenue generated for an invoice" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      expect(page).to have_content("Total revenue: $1,000.00")

    end
  end

  #US 18
  describe "Merchant Invoice Show Page: Update Item Status" do
    it "select field and update button" do
      visit"/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
      
      
      within("#item-#{@item_1.id}") do
        click_button("Update Item Status")
      end

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")
    end
  end

  describe "discounted revenue" do
    
    #Discounts US 6
    it "shows the new discounted revenue from the invoice" do
      visit"/merchants/#{@merchant_3.id}/invoices/#{@invoice_8.id}"

      expected = "Total revenue: $1,050.00"
      expected_discount = "Total discounted revenue: $800.00"
      expect(page).to have_content(expected)
      expect(page).to have_content(expected_discount)
    end

    #Discounts US 7
    it "links each item to the discount applied" do
      visit"/merchants/#{@merchant_3.id}/invoices/#{@invoice_8.id}"

      within("#item-#{@item_9.id}") do
        expect(page).to have_link("#{@discount_1.id}")
        click_on("#{@discount_1.id}")
        expect(current_path).to eq(merchant_discount_path(@merchant_3, @discount_1))
      end
    end
  end
end