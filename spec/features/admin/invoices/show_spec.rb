require "rails_helper"

RSpec.describe "Admin Invoices Index Page" do
  before :each do
    @customer = create(:customer)
    @invoice1 = create(:invoice, customer: @customer, status: 0)
    
    # Create first item and associated invoice item
    @item1 = create(:item) 
    @invoice_item1 = create(:invoice_item, invoice: @invoice1, item: @item1)
    
    # Create second item and associated invoice item
    @item2 = create(:item) 
    @invoice_item2 = create(:invoice_item, invoice: @invoice1, item: @item2)

    # Create a transaction for the invoice
    create(:transaction, invoice: @invoice1) 

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

  # US 33
  it "lists all of the invoice details on the show page" do
    visit admin_invoice_path(@invoice1.id)

    expect(page).to have_content("ID: ##{@invoice1.id}")
    expect(page).to have_content("Status: #{@invoice1.status}")
    expect(page).to have_content("Customer: #{@invoice1.customer.full_name}")
    expect(page).to have_content("Created Date: #{@invoice1.date_format}")
  end

  # US 34
  it "displays all invoice items and attributes" do
    visit admin_invoice_path(@invoice1.id)

    @invoice1.invoice_items.each do |invoice_item|
      within("#invoice-item-#{invoice_item.id}") do
        expect(page).to have_content("Item: #{invoice_item.item.name}")
        expect(page).to have_content("Quantity Ordered: #{invoice_item.quantity}")
        expect(page).to have_content("Sold Price: #{invoice_item.unit_price}")
        expect(page).to have_content("Invoice Item Status: #{invoice_item.status}")
      end
    end
  end 

  # US 35
  it "displays the total revenue generated from the invoice" do
    visit admin_invoice_path(@invoice1.id)

    expect(page).to have_content("Total Revenue: $#{@invoice1.total_revenue}")
  end

  # US 36
  it "displays a select field for invoice status and updates the field" do
    visit admin_invoice_path(@invoice1.id)

    expect(@invoice1.status).to eq("in progress")

    select "completed", from: "status"
    click_button "Update Invoice Status"

    @invoice1.reload

    expect(@invoice1.status).to eq("completed")
  end

  #Discounts US 8
  it "displayes total discounted revenue for an invoice" do
    visit admin_invoice_path(@invoice_8)

    expected_discount = "Total discounted revenue: $800.00"
    expect(page).to have_content(expected_discount)
  end
end 