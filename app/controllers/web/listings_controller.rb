class Web::ListingsController < Web::ApplicationController
  def index
    @listings = Listing.order_by(created_at: 'desc')

    respond_to do |format|
      format.html
      format.csv { send_data @listings.to_csv }
    end    
  end

  def summary
    @listings = Listing.order_by(created_at: 'desc')
  end  
end