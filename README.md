# Kuikka Website - Powered by Elixir
[![build status](https://travis-ci.org/osasto-kuikka/kuikka-website.svg?branch=master)](https://travis-ci.org/osasto-kuikka/kuikka-website)

## Setup Development environment
Required:
* Erlang 19.0
* Elixir 1.3.4
* Nodejs 6.9
* Postgresql 9.5

### Windows
Install with [Chocolatey](https://chocolatey.org/install)
```
choco install -y erlang elixir nodejs VisualCppBuildTools
```

### Linux
* Arch
  * `pacman -S install erlang elixir nodejs postgresql`
* Fedora 25
  * `dnf install -y erlang nodejs postgresql-server`
  * Elixir 1.3.4 needs to be installed manually as fedora repository only has
      1.3.1 which is not supported

### Install postgresql
Install [postgresql 9.5](https://www.postgresql.org/download/)
* By default this project uses `postgres` username and password

### Project setup
Available commands for project setup:
**NOTICE: On windows you need to run dev.bat before compiling**
```
mix setup (Setup everything with one command)
mix setup.min (Get dependencies and compile)
mix frontend.install (Install npm packages to frontend)
mix frontend.build (Build minified javascript)
mix db.setup (Setup database)
mix db.reset (Reset database)
```

### Get Steam API key (required for login functionality)
* [Get key from here](http://steamcommunity.com/dev/apikey)
* Add key to your environment variable as `STEAM_API_KEY`

## Running the application
```
iex -S mix (Start console for program)
mix run --no-halt (Run program)
```

## Running test
```
mix test (Run unit tests)
mix lint (Run linter)
```

## Create release build
```
MIX_ENV=prod mix release --env=prod
```
