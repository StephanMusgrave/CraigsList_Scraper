namespace :scraper do
  desc "Fetch Craigslist posts from 3taps"
  task scrape: :environment do
    require 'open-uri'
    require 'JSON'

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

    # Display results to screen
    puts JSON.pretty_generate result

  end

  desc "TODO"
  task destroy_all_posts: :environment do
  end

end
