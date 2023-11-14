class Merchants::InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end
  def update
    @item = Item.find(params[:item_id])
    
    if params[:status] == "Enabled"
      @item.update(status: 0)
    elsif params[:status] == "Disabled"
      @item.update(status: 1)
    end

    redirect_to "/merchants/#{params[:merchant_id]}/invoices/#{params[:id]}"
  end
end