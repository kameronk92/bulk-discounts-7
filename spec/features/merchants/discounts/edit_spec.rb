require "rails_helper"

RSpec.describe "merchant discounts edit page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @discount_1 = @merchant_1.discounts.create(percentage: 0.5, quantity: 40)
    @discount_2 = @merchant_1.discounts.create(percentage: 0.1, quantity: 5)
    @discount_3 = @merchant_2.discounts.create(percentage: 0.15, quantity: 5)
  end

  it "is linked from the discount show page" do
    visit merchant_discount_path(@merchant_1, @discount_1)
    expect(page).to have_content("Discount #{@discount_1.id} Show Page")
    expect(page).to have_link("Edit Discount #{@discount_1.id} Details")
    click_link("Edit Discount #{@discount_1.id} Details")
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/#{@discount_1.id}/edit")
  end

  it "is prefilled with discount attributes" do
    visit edit_merchant_discount_path(@merchant_1, @discount_1)
    expect(page).to have_field(:percentage, with: @discount_1.pretty_percent)
    expect(page).to have_field(:quantity, with: @discount_1.quantity)
    expect(page).to have_button("Update Discount")
  end

  it "updates attributes and redirects to discount show page" do
    visit edit_merchant_discount_path(@merchant_1, @discount_1)
    fill_in "percentage", with: 0.6
    fill_in "quantity", with: 40
    click_button "Update Discount"
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/#{@discount_1.id}")
    expect(page).to have_content("60% off, after 40 of any item purchased")
    expect(page).to have_content("Discount successfully updated")
  end

  it "shows an error if a field is left blank" do
    visit edit_merchant_discount_path(@merchant_1, @discount_1)
    fill_in "percentage", with: ""
    click_button "Update Discount"
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/#{@discount_1.id}/edit")
    expect(page).to have_content("Discount update failed")
  end
end
