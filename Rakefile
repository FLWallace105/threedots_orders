require 'dotenv'
#require 'active_record'
require 'shopify_api'
#require 'sinatra/activerecord/rake'

require_relative 'threedots_orders'

#require 'active_record/railties/databases.rake'

Dotenv.load


namespace :pull_shopify do
    desc 'Get Threedots order fulfillment info from CSV'
    task :get_orders do |t|
        
        Threedots::ShopifyGetter.new.get_orders
    end

end