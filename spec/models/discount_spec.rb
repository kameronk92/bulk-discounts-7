require "rails_helper"

RSpec.describe Discount, type: :model do
  describe "relationships" do
    it { should belong_to :merchant}
  end

  describe "validations" do
    it { should validate_presence_of :percentage}
    it { should validate_presence_of :quantity}
  end

  describe "instance methods" do
    describe "#pretty_percent" do
      it "returns the percentage as a string" do
        discount = Discount.new(percentage: 1, quantity: 5)
        discount2 = Discount.new(percentage: 0.2, quantity: 5)
        expect(discount.pretty_percent).to eq("100%")
        expect(discount2.pretty_percent).to eq("20%")
      end
    end
  end
end