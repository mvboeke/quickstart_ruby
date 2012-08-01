require "sinatra"
require "braintree"
require "shotgun"

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "QuickStart_Merchant"
Braintree::Configuration.public_key = "QuickStart_Public"
Braintree::Configuration.private_key = "QuickStart_Private"

get '/' do
  tr_data = Braintree::TransparentRedirect.transaction_data(
    :redirect_url => "http://localhost:9393/braintree",
    :transaction => {
      :type => "sale",
      :amount => "1000.00"
    }
  )

  erb :form, :locals => {:tr_data => tr_data}
end

get "/braintree" do
  result = Braintree::TransparentRedirect.confirm(
    request.query_string
  )

  if result.success?
     message = "Transaction Successful"
  else
     message = result.errors
  end

  erb :response, :locals => {:message => message}
end
