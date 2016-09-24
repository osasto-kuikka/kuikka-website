# Kuikka Website - Powered by Elixir
[![build status](https://gitlab.com/osasto-kuikka/kuikka-website/badges/master/build.svg)](https://gitlab.com/osasto-kuikka/kuikka-website/commits/master)
[![coverage report](https://gitlab.com/osasto-kuikka/kuikka-website/badges/master/coverage.svg)](https://gitlab.com/osasto-kuikka/kuikka-website/commits/master)

## Dev requirements
- [Erlang 19](https://www.erlang.org/downloads)
- [Elixir 1.3.3](http://elixir-lang.org/install.html)
- [Phoenix Framework](http://www.phoenixframework.org/docs/installation)

## Setting up the development environment
1. Download dev requirements
2. Run `mix.setup`
  - If you don't want npm install run `mix setup.min`

## Running the application
- `iex -S mix` to start with console
- `mix run --no-halt` to start without console

## Running test
- `mix lint` to run code linter
- `mix test` to run tests
- `mix test --cover` to run tests and get coverage report
- `mix coveralls --umbrella` to get coverage for whole project

## Creating release build
- `mix release` to build release
  - Set MIX_ENV and NODE_ENV enviroment variable to prod for full release build
    - `export MIX_ENV=prod`
    - `export NODE_ENV=prod`

## Continuous integration
Currently our CI runs these tests:
- `mix lint`
- `mix test --cover`
- `mix release --warnings-as-errors`
These tests need to pass before merge request can be accepted!

