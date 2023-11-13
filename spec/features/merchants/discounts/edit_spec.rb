require "rails_helper"

RSpec.describe "merchant discounts edit page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @discount_1 = @merchant_1.discounts.create(percentage: 0.5, quantity: 40)
    @discount_2 = @merchant_1.discounts.create(percentage: 0.1, quantity: 5)
    @discount_3 = @merchant_2.discounts.create(percentage: 0.15, quantity: 5)
  end

  it "allows a merchant to edit their discounts" do
    visit (merchant_discount_show_path(@merchant_1, @discount_1))
    expect(page).to have_content("Discount #{@discount_1} Show Page")

  end
end