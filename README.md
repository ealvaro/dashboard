Dashboard
=======

Dashboard is a web application that tracks real-time updates and software installations from tools out in the field.


Stack
-----

* Rails 4.0
* Ruby 2.2
* minitest
* no background jobs
* Stores files on S3
* postgresql on the backend
* hosted on heroku (http://tracker-wolf.herokuapp.com)

Notes
-----

Several API calls require authentication using a common secret token.

Areas of the app
----------------

* User interface
* Admin
* Push (the API)

Getting Started
---------------

0. Clone
0. gem install bundler
0. cp .env.sample to .env and fill out
0. cp database.yml.sample to database.yml
0. use ruby 2.2.2 (or have `rvm` installed and it will pick the right ruby version)
0. `bundle install`
0. `spring rake db:create db:migrate db:seed`

Api Call Examples
-----------------

Be sure to look at the /test/fixtures to see other example api calls.

```
  {
    "event_type_id": 2,
    "uid": "fee7dade",
    "time": 1395173704,
    "reporter_type": 1,
    "software_installation_id": "the-id",
    "board_firmware_version": "6.5.6",
    "board_serial_number": "666",
    "chassis_serial_number": "4730",
    "primary_asset_number": "125",
    "secondary_asset_numbers": "234,567,345",
    "user_email": "example@example.com",
    "region": "the-region",
    "notes": "optional",
    "memory_usage_level": "1000",
    "hardware_version": "2.0.1",
    "reporter_version": "1.1.0",
    "job_number": "1342",
    "run_number": "123",
    "reporter_context": "debugger",
    "assets": {
        "main": "filename-version.hex",
        "version1": "filename-version-1.hex",
        "version2": "filename-version-2.hex"
    },
    "configuration": {
        "key": "value"
    }
  }
```
