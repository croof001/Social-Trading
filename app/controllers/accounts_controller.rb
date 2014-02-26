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
      @account = Account.new(:client=>current_client,:name=>:Wordpress,:account_type=>type)
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
    if params[:account] then info={:provider=>'wordpress'} else info = request.env['omniauth.auth'] end
    
    if info[:provider]=='facebook'
      @account= Account.find_or_create_by(:account_type=>'fb',:client=>current_client,:cred1=>info[:uid]) { |a|
                 a.name= 'Facebook'
                 a.cred2= info[:credentials][:token]
                 a.username=info[:info][:nickname]
                 a.active=true
                 a.primary = true if not Account.where(:client=>current_client,:account_type=>'fb').exists?
                 a.email=info[:info][:email]}
      
    elsif info[:provider] =='twitter'
    
      @account= Account.find_or_create_by(:account_type=>'ttr',:client=>current_client,:username=>info.info.nickname) { |a|
                 a.name    = 'Twitter'
                 a.cred2   = info.credentials.secret.to_s
                 a.cred1   = info.credentials.token
                 a.active  = true
                 a.primary = true if not Account.where(:client=>current_client,:account_type=>'ttr').exists?
                 a.email=info.info.email}
      flash[:notice] = 'Twitter account connected successfully'
    elsif info[:provider]=='wordpress'
       values = params.require(:account).permit(:account_type,:name,:username,:cred1,:cred2,:cred3)
       @account = Account.new(values)
       puts "--------------------------Validating-------------"
       valid = @account.validate_cred
       puts "-----------------------------------validity #{valid}x"
       @account.client = current_client
       @account.primary = true if not Account.where(:client=>current_client,:account_type=>'wp').exists?
    end
    
    if @account.save
        flash[:notice] = "#{@account.name} account connected successfully"
    else
        flash[:notice] = "Error occured while connecting your #{@account.name} account"
    end
    render :text=> "<script>window.opener.location.reload();window.close();</script>"
    
  end
  
  
end
