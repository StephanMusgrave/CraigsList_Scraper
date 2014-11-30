namespace :scraper do
  desc "Fetch Craigslist posts from 3taps"
  task scrape: :environment do
    require 'open-uri'
    require 'json'

    # set API token and URL
    auth_token = "b6ae9b063b9409eb915ab1c32b30ad62"
    polling_url = "http://polling.3taps.com/poll"

    # Grab data until up to date
    loop do

      # Specify request parameters
      params = {
        auth_token: auth_token,
        anchor: Anchor.first.value,
        source: "CRAIG",
        category_group: "RRRR",
        category: "RHFR",
        'location.city' => "USA-NYM-BRL",
        retvals: "location,external_url,heading,body,timestamp,price,images,annotations"
      }

      # Prepare API request
      uri = URI.parse(polling_url)
      uri.query = URI.encode_www_form(params)

      # Submit request
      result = JSON.parse(open(uri).read)

       # Store results in a database
      result["postings"].each do |posting|
        # Create new Post
        @post = Post.new
        @post.heading        = posting["heading"]
        @post.body           = posting["body"]
        @post.price          = posting["price"]
        @post.neighborhood   = Location.find_by(code: posting["location"]["locality"]).try(:name)
        @post.external_url   = posting["external_url"]
        @post.timestamp      = posting["timestamp"]
        @post.bedrooms       = posting["annotations"]["bedrooms"]       if posting["annotations"]["bedrooms"].present?
        @post.bathrooms      = posting["annotations"]["bathrooms"]      if posting["annotations"]["bathrooms"].present?
        @post.sqft           = posting["annotations"]["sqft"]           if posting["annotations"]["sqft"].present?
        @post.cats           = posting["annotations"]["cats"]           if posting["annotations"]["cats"].present?
        @post.dogs           = posting["annotations"]["dogs"]           if posting["annotations"]["dogs"].present?
        @post.w_d_in_unit    = posting["annotations"]["w_d_in_unit"]    if posting["annotations"]["w_d_in_unit"].present?
        @post.street_parking = posting["annotations"]["street_parking"] if posting["annotations"]["street_parking"].present?

        # Save Post
        @post.save

        # Loop through images and save to Image database
        posting["images"].each do |image|
          @image = Image.new
          @image.url = image["full"]
          @image.post_id = @post.id
          @image.save
        end 
      end

      Anchor.first.update(value: result["anchor"])
      puts Anchor.first.value
      break if result["postings"].empty?
    end
  end

  desc "Destroy all posting data"
  task destroy_all_posts: :environment do
    Post.destroy_all
  end
  
  desc "Save neighbourhood codes in a reference table"
  task scrape_neighbourhoods: :environment do
    require 'open-uri'
    require 'json'

    # set API token and URL
    auth_token = "b6ae9b063b9409eb915ab1c32b30ad62"
    location_url = "http://reference.3taps.com/locations"

    # Specify request parameters
    params = {
      auth_token: auth_token,
      level: "locality",
      city: "USA-NYM-BRL"
    }

    # Prepare API request
    uri = URI.parse(location_url)
    uri.query = URI.encode_www_form(params)

    # Submit request
    result = JSON.parse(open(uri).read)

    # Display results to screen
    # puts JSON.pretty_generate result

    # Store results in a database
    result["locations"].each do |location|
      @location = Location.new
      @location.code = location["code"]
      @location.name = location["short_name"]
      @location.save
    end
  end

  desc "Display Craigslist posts from 3taps"
  task display: :environment do
    require 'open-uri'
    require 'json'

    # set API token and URL
    auth_token = "b6ae9b063b9409eb915ab1c32b30ad62"
    polling_url = "http://polling.3taps.com/poll"

    # Specify request parameters
    params = {
      auth_token: auth_token,
      anchor: 1526310618,
      source: "CRAIG",
      category_group: "RRRR",
      category: "RHFR",
      'location.city' => "USA-NYM-BRL",
      retvals: "location,external_url,heading,body,timestamp,price,images,annotations"
    }

    # Prepare API request
    uri = URI.parse(polling_url)
    uri.query = URI.encode_www_form(params)

    # Submit request
    result = JSON.parse(open(uri).read)

    result["postings"].each do |posting|
      # Create new Post
      @post = Post.new
      @post.heading        = posting["heading"]
      @post.body           = posting["body"]
      @post.price          = posting["price"]
      @post.neighborhood   = Location.find_by(code: posting["location"]["locality"]).try(:name)
      @post.external_url   = posting["external_url"]
      @post.timestamp      = posting["timestamp"]
      @post.bedrooms       = posting["annotations"]["bedrooms"]       if posting["annotations"]["bedrooms"].present?
      @post.bathrooms      = posting["annotations"]["bathrooms"]      if posting["annotations"]["bathrooms"].present?
      @post.sqft           = posting["annotations"]["sqft"]           if posting["annotations"]["sqft"].present?
      @post.cats           = posting["annotations"]["cats"]           if posting["annotations"]["cats"].present?
      @post.dogs           = posting["annotations"]["dogs"]           if posting["annotations"]["dogs"].present?
      @post.w_d_in_unit    = posting["annotations"]["w_d_in_unit"]    if posting["annotations"]["w_d_in_unit"].present?
      @post.street_parking = posting["annotations"]["street_parking"] if posting["annotations"]["street_parking"].present?

      puts posting["annotations"] if posting["annotations"]["street_parking"].present?

    end
  end

  desc "Discard old data"
  # 6 hours gives ~100 pages @ 20 posts/page and warning email: 
  # "The database contains 15,558 rows, exceeding the Hobby-dev plan limit of 10,000. "
  task discard_old_data: :environment do
    Post.all.each do |post|
      if post.created_at < 3.hours.ago
        post.destroy
      end
    end
  end

end
