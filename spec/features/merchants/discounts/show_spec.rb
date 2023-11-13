require "rails_helper"

RSpec.describe "merchant discount show page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @discount_1 = @merchant_1.discounts.create(percentage: 0.5, quantity: 40)
    @discount_2 = @merchant_1.discounts.create(percentage: 0.1, quantity: 5)
    @discount_3 = @merchant_2.discounts.create(percentage: 0.15, quantity: 5)
  end

  it "shows the discounts amount and threshold" do
    visit merchant_discounts_path(@merchant_1)
    click_on "#{@discount_1.id}"
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/#{@discount_1.id}")
    expect(page).to have_content("#{@discount_1.id}")
    expect(page).to have_content(@discount_1.pretty_percent)
    expect(page).to have_content("#{@discount_1.quantity}")
  end
end