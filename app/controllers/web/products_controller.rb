class Web::ProductsController < Web::ApplicationController
  def index
    @products = Product.order_by(created_at: 'desc')

    respond_to do |format|
      format.html
      format.csv { send_data @products.to_csv }
    end    
  end
end