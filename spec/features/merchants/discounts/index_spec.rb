require "rails_helper"

RSpec.describe "merchant discounts index page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @discount_1 = @merchant_1.discounts.create(percentage: 0.5, quantity: 40)
    @discount_2 = @merchant_1.discounts.create(percentage: 0.1, quantity: 5)
    @discount_3 = @merchant_2.discounts.create(percentage: 0.15, quantity: 5)
  end

  #Discounts US 1
  it "shows all a merchant's bulk discounts" do
    visit "/merchants/#{@merchant_1.id}/discounts"

    expect(page).to have_content("1. #{(@discount_1.percentage * 100).round(0)}% off, after #{@discount_1.quantity} of any item purchased")
    expect(page).to have_content("2. #{(@discount_2.percentage * 100).round(0)}% off, after #{@discount_2.quantity} of any item purchased")
    expect(page).to_not have_content("#{@discount_3.percentage}")
  end
end