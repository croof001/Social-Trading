class DashboardController < ApplicationController
  before_filter :authenticate_client! ,except: [:welcome]
  def index
    
  end
  
  def welcome
    
  end
end
