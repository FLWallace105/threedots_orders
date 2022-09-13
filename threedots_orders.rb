#threedots_orders.rb
require 'dotenv'
require 'httparty'
require 'shopify_api'

Dotenv.load


module Threedots
    class ShopifyGetter

        def initialize
            @shopname = ENV['SHOPIFY_SHOP_NAME']
            @api_key = ENV['SHOPIFY_API_KEY']
            @password = ENV['SHOPIFY_API_PASSWORD']
            @secret = ENV['SHOPIFY_SHARED_SECRET']
            @app_token = ENV['APP_TOKEN']
      
            
        end


        def get_orders
            puts "starting ...."

            puts "#{@api_key}, #{@secret}, #{@shopname}, #{@app_token}"


            ShopifyAPI::Context.setup(
                api_key: "DUMMY",
                api_secret_key: @app_token,
                scope: "DUMMY",
                host_name: "DUMMY",
                private_shop: "#{@shopname}.myshopify.com",
                session_storage: ShopifyAPI::Auth::FileSessionStorage.new,
                is_embedded: false, 
                is_private: true, 
                api_version: "2022-07"
        
            )



            order_array = Array.new
            order_array_status = Array.new

             CSV.foreach('threedots_orders.csv', :encoding => 'ISO-8859-1', :headers => true) do |row|
                 puts row.inspect
                 order_array << row['Pick Ticket']

             end

             order_array.each do |myord|
                temp_order = ShopifyAPI::Order.find(id: myord)
                puts "-------"
                puts temp_order.original_state[:line_items]
                puts temp_order.original_state[:line_items][0]['fulfillment_status']
                my_hash = {"pick_ticket" => myord, "fulfillment_status" => temp_order.original_state[:line_items][0]['fulfillment_status']}
                order_array_status.push(my_hash)
                puts "-------"

             end

            File.delete('threedots_fulfillment_status.csv') if File.exist?('threedots_fulfillment_status.csv')

            column_header = ["pick_ticket", "fulfillment_status" ]

            CSV.open('threedots_fulfillment_status.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
                column_header = nil
                order_array_status.each do |mys|
                    
                    hdr << mys
                end


            end



        end



    end
end