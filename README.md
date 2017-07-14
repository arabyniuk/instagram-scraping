# Instagram Scraping

## Configuration

You should have application.yml file first and put it into config/ folder.

## Seed

Launch app first:

```console
$ bundle exec rake db:create
$ bundle exec rake db:migrate
$ bundle exec rails s
```

To seed db with Hotel from csv:

```console
$ bundle exec rake db:seed
```

It also get location_id number by latitude/longitude via instagram API
through Rails model callback.

Note: there are just 500 requests/hour to Instagram API. One hotel - one
request.

## Location Id

To get location_id manually for a Hotel record with latitude/longitude
value, if it exist:

```ruby
Hotel.find(%id%).set_location_id
```

## Track changes on InstagramPost and Poster model

Basic usage:

```ruby
widget = Widget.find 153
widget.name                                 # 'Doobly'

# Add has_paper_trail to Widget model.

widget.versions                             # []
widget.update_attributes name: 'Wotsit'
widget.versions.last.reify.name             # 'Doobly'
widget.versions.last.event                  # 'update'
```

More info: https://github.com/airblade/paper_trail

## Scrape media list and poster manually

To launch scraping media list with tag and location_id manually:

```console
$ bundle exec rake instagram_scraper:media_link
```

Check poster info changes:

```console
$ bundle exec rake instagram_scraper:poster_info
```

## Cron job

to apply cron-tasks in development env:

```console
$ whenever --update-crontab --set environment=development 
```
