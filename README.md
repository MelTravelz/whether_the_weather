# Whether the Weather

Need to determine the weather forecast at your road trip arrival destination?
Then, you came to the right place!

<br>

`Whether the Weather` was inspired by this wickedly witty tongue twister:

<br>

```
Whether the weather be cold,
or whether the weather be hot, 
we'll be together, 
whatever the weather, 
whether you like it or not! 

...cuz we're going on a roadtrip, oh yea baby!
```

<br>

## Learning Goals

- Consume 2+ external endpoints
- Build 4 endpoints that return JSON responses
- Develop robust happy & sad path tests
- Authenticate users 
- Refactor code for better readability

<br>

## Getting Started

If you'd like to demo this API on your local machine:
- Ensure you have all prerequisites & API keys
- Clone this repo: `git clone git@github.com:MelTravelz/whether_the_weather.git`
- Then run:
    - `bundle install`
    - `bundle exec figaro install`
    - `rails db:{create,migrate,seed}`
- In the "app/config/application.yml' file add you API keys:
    - `MAPQUEST_API_KEY: api_key_add_here`
    - `WEATHER_API_KEY: api_key_add_here`
- To run all tests run:
    - `bundle exec rspec`

<br>

## Grab your API key

Sign up for your own API Keys:
- [MapQuest API Key](https://developer.mapquest.com/user/login/sign-up)
- [Weather API Key](https://www.weatherapi.com/signup.aspx)

<br>

## Prerequisites

- Ruby Version 3.1.1
- Rails Version 7.0.4.x
- Bundler Version 2.4.9

<br>

## Happy Path Endpoints

`GET "/api/v1/forecast"`

Response:
```
{
    "data": {
        "id": null,
        "type": "forecast",
        "attributes": {
            "current_weather": {
                "last_updated": "2023-04-26 01:45",
                "temperature": 48.9,
                "feels_like": 46.2,
                "humidity": 41,
                "uvi": 1.0,
                "visibility": 9.0,
                "condition": "Clear",
                "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png"
            },
            "daily_weather": [
                {
                    "date": "2023-04-26",
                    "sunrise": "06:02 AM",
                    "sunset": "07:47 PM",
                    "max_temp": 59.5,
                    "min_temp": 49.5,
                    "condition": "Patchy rain possible",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png"
                }, {...etc...}
            ],
            "hourly_weather": [
                {
                    "time": "00:00",
                    "temperature": 53.2,
                    "conditions": "Clear",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png"
                }, {...etc...}
            ]
        }
    }
}
```

<br>
<hr>
<br>

`POST "/api/v1/users"`

Request Body:
```
{
    "data": {
        "id": "155",
        "type": "users",
        "attributes": {
            "email": "whatever@example.com",
            "api_key": "c4ac36f7672d32a72df17863933f7377"
        }
    }
}
```
Response:
```
{
    "data": {
        "id": "155",
        "type": "users",
        "attributes": {
            "email": "whatever@example.com",
            "api_key": "c4ac36f7672d32a72df17863933f7377"
        }
    }
}
```

<br>
<hr>
<br>

`POST "/api/v1/sessions"`

Request Body:
```
{
  "email": "whatever@example.com",
  "password": "password"
}
```
Response:
```
{
    "data": {
        "id": "155",
        "type": "users",
        "attributes": {
            "email": "whatever@example.com",
            "api_key": "c4ac36f7672d32a72df17863933f7377"
        }
    }
}
```

<br>
<hr>
<br>

`POST "/api/v1/road_trip"`

Request Body:
```
{
  "origin": "New York, NY",
  "destination": "Los Angeles, CA",
  "api_key": "t1h2i3s4_i5s6_l7e8g9i10t11"
}
```
Response: 
```
{
    "data": {
        "id": null,
        "type": "road_trip",
        "attributes": {
            "start_city": "New York, NY",
            "end_city": "Los Angeles, CA",
            "travel_time": "40:11:02",
            "weather_at_eta": {
                "datetime": "2023-04-27 13:00",
                "temperature": 85.6,
                "condition": "Sunny"
            }
        }
    }
}
```
