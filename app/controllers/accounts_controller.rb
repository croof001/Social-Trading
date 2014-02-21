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
  
  def make_primary
    @account = Account.find(params[:account_id])
    current = Account.where(:account_type=>@account.account_type,:primary=>true)
    if current.exists?
      current = current.first
      current.primary = false
      current.save
    end
    @account.primary = true
    @account.save
    respond_to do |format|
      format.html {redirect_to current_client , notice: 'Primary account changed'}
    end
  end
  
  def create
    
    info = request.env['omniauth.auth']
    if info[:provider]=='facebook'
      @account= Account.find_or_create_by(:account_type=>'fb',:client=>current_client,:cred1=>info[:uid]) { |a|
                 a.name= 'Facebook'
                 a.cred2= info[:credentials][:token]
                 a.username=info[:info][:nickname]
                 a.active=true
                 a.primary = true if not Account.where(:client=>current_client,:account_type=>'fb').exists?
                 a.email=info[:info][:email]}
      @account.save
      flash[:notice] = 'Facebook account coonected successfully'
    elsif info[:provider] =='twitter'
    
      @account= Account.find_or_create_by(:account_type=>'ttr',:client=>current_client,:username=>info.info.nickname) { |a|
                 a.name    = 'Twitter'
                 a.cred2   = info.credentials.secret.to_s
                 a.cred1   = info.credentials.token
                 a.active  = true
                 a.primary = true if not Account.where(:client=>current_client,:account_type=>'ttr').exists?
                 a.email=info.info.email}
      @account.save
      flash[:notice] = 'Twitter account connected successfully'
    end
    render :text=> "<script>window.opener.location.reload();window.close();</script>"
  end
end
