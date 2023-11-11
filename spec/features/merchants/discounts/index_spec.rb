require "rails_helper"

RSpec.describe "merchant discounts index page" do
  before :each do
    @merchant_1 = create(:merchant)
    @discount_1 = @merchant_1.discounts.new(percentage: 0.5, quantity: 4)
  end

  #Discounts US 1
  it "shows all a merchant's bulk discounts" do
    visit "/merchants/#{@merchant_1.id}/discounts"
    expect(page).to have_content(@merchant_1.discounts)
  end
end