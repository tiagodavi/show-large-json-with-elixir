# App

## You have Elixir/Erlang/Node installed 

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install && cd ../`
  * Run tests `MIX_ENV=test mix test`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## You prefer to use Docker

* Build the image and container `docker-compose up -d`
* Start the container `docker container exec -it app sh` 
* Install dependencies `mix deps.get` 
* Install Node.js dependencies `cd assets && npm install && cd ../`
* Run tests `MIX_ENV=test mix test`
* Start phoenix `mix phx.server` 

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Settings

- Elixir 1.10.1
- Erlang/OTP 22 
- Phoenix framework 1.4.14
- Default Environment variables: MIX_ENV as dev
- Database: no
- Stream Large JSON files: https://github.com/boudra/jaxon
- Generate CSV files: https://github.com/beatrichartz/csv

## Screen 

![Image description](https://github.com/tiagodavi/show-large-json-with-elixir/blob/master/system.png)
