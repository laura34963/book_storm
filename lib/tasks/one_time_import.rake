namespace :one_time_import do 
	desc 'Import book store data'
	task :run_stores => :environment do
		json = File.read("#{Rails.root}/tmp/data/book_store_data.json")
    stores = JSON.parse(json)

    i = 1
    stores.each do |store|
      s = Store.create(name: store["storeName"], balance: store["cashBalance"])
      # s.name = store["storeName"]
      # s.balance = store["cashBalance"]
      # s.save

      business_hours = store["openingHours"].split(" / ")
      business_hours.each do |business_hour|
        match =  /(\w*)[\,\- ]*(\w*) (\d+[:\d+]* \w*) - (\d+[:\d+]* \w*)/.match(business_hour)
        # Remove all punctuation
        binding.pry if match.nil?
        starting_time = Time.parse(match[3]).strftime("%H%M")
        ending_time = Time.parse(match[4]).strftime("%H%M")
        [match[1], match[2]].each do |weekday|
        	next if weekday.blank?
        	u = Date.strptime(weekday[0..2], "%A").wday
        	s.business_hours.create(opentime: "#{u}#{starting_time}", closetime: "#{u}#{ending_time}")
        end
    	end

       # /(\w*\, \w{3}) (\d+:\d+ \w*) - (\d+[:\d+]* \w*)/

      store["books"].each do |book|
        s.books.create(name: book["name"], price: book["price"])
      end
    end
	end


	desc 'Import'
	task :run_users => :environment do
		json = File.read("#{Rails.root}/tmp/data/user_data.json")
    users = JSON.parse(json)
    store_name_id_map = Store.pluck(:name, :id).to_h
    book_name_id_map = Book.pluck(:name, :id).to_h


    users.each do |user|
    	u = User.create(name: user["name"], balance: user["cashBalance"])

    	user["purchaseHistory"].each do |record|
    		u.purchase_histories.create(
    			date: record["transactionDate"],
    			amount: record["transactionAmount"],
    			store_id: store_name_id_map[record["storeName"]],
    			book_id: book_name_id_map[record["bookName"]]
    			)
    	end
    end
	end
end