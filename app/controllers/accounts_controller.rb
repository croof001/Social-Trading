class AccountsController < ApplicationController
  before_action :authenticate_client!
  
  
  
  def destroy
    Account.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to current_client }
      format.json { head :no_content }
    end
  end
  
  
  
  def new
    type = params[:type]
    if type=='fb'
      redirect_to '/auth/facebook'
    elsif type=='ttr'
      redirect_to '/auth/twitter'

    elsif type=='pin'
      
    elsif type=='wp'
      
    elsif type=='blog'
      
    end
  end
  
  def create
    
    info = request.env['omniauth.auth']
    if info[:provider]=='facebook'
      @account= Account.find_or_create_by(:account_type=>'fb',:client=>current_client,:cred1=>info[:uid]) { |a|
                 a.name= 'Facebook'
                 a.cred2= info[:credentials][:token],
                 a.username=info[:info][:nickname],
                 a.active=true,
                 a.email=info[:info][:email]}
      @account.save
      flash[:notice] = 'Facebook account coonected successfully'
    end
    
    
    redirect_to current_client
  end
end
