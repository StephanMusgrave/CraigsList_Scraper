# Craigslist Scraper

A project to develop an apartment rental site like Craigslist, following a [BaseRails] course.

![](public/image.jpg)

## Learning Objectives
- To build an apartment rental site like Craigslist
- Learn to use an API to scrape Craigslist apartment rental data. 
- Build a beautiful web app to display live listings with filters.

## How to run it
```sh
git clone git@github.com:StephanMusgrave/CraigsList_Scraper.git
cd craigslist_scraper
rails s

```

## Refresh the data on local
```
$ bin/rake scraper:scrape
$ bin/rake scraper:discard_local_old_data
```

Heroku
----
Click here to open the web page on Heroku: [App on Heroku]

## Technologies used

|Technology                 |Used for                        |
|---------------------------|--------------------------------|
|Ruby 2.1.2                 |Main programming language       |
|Ruby on Rails 4.1.1        |Model View Controller Framework |
|Heroku                     |Deployment: [App on Heroku]     |
|Sqlite3                    |SQL Database for development    |
|3taps API [3taps]          |searches Twitter, Craigslist and other sites for postings |
|Postgrsql                  |SQL Database for deployment     |
|Devise                     |Enabling users and admins       |
|Dropbox                    |Bulk image hosting              |
|Paperclip                  |A file attachment library for Active Record, used for uploading images |
|paperclip-dropbox          |extends Paperclip with Dropbox storage|
|Figaro                     |handling passwords and keys     |
|HTML5                      |Web Pages                       |
|CSS3                       |Styling                         |
|Bootstrap                  |Base styling theme              |
|will_paginate              |Pagination library              |
|Glypicons                  |for styling links and buttons   |
|Javascript                 |animations for alerts           |
|New Relic                  |Real time application monitoring|
|Papertrail                 |Tracking events & log management|
|Google Analytics           |website statistics              |
|SendGrid                   |confirmation emails             |


## Developed by

[Steve Musgrave]

## Further work to do

[Steve Musgrave]:https://github.com/StephanMusgrave
[App on Heroku]:https://homefinder-musgrave.herokuapp.com/
[BaseRails]:https://www.baserails.com/
[3taps]:https://developer.3taps.com