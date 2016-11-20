# Kuikka Website - Powered by Elixir
[![build status](https://gitlab.com/osasto-kuikka/kuikka-website/badges/master/build.svg)](https://gitlab.com/osasto-kuikka/kuikka-website/commits/master)
[![coverage report](https://gitlab.com/osasto-kuikka/kuikka-website/badges/master/coverage.svg)](https://gitlab.com/osasto-kuikka/kuikka-website/commits/master)

## Setup required programs
### Windows
1. Install [Chocolatey](https://chocolatey.org/install)
2. `choco install erlang`
3. `choco install elixir`
4. `choco install nodejs`
6. `choco install VisualCppBuildTools`
7. Install [postgresql 9.5](http://www.enterprisedb.com/products-services-training/pgdownload#windows)
  * Set username and password as `postgres`

### Linux (Arch)
1. `pacman -S install erlang`
2. `pacman -S install elixir`
3. `pacman -S install nodejs`
4. Install [postgresql 9.5](http://www.enterprisedb.com/products-services-training/pgdownload#linux)
  * Set username and password as `postgres`

### Linux (Fedora 25)
1. `dnf install erlang`
2. `dnf install elixir`
3. `dnf install nodejs`
4. Install [postgresql 9.5](http://www.enterprisedb.com/products-services-training/pgdownload#linux)
  * Set username and password as `postgres`

## Setup development environment

### NOTICE:
##### On windows you need to run dev.bat in cmd to get compiling to work

* Install phoenix
  * Run `mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez`
* Run `mix setup`
  * If you don't want npm install or database run `mix setup.min`
  * To setup database `mix db.setup` (this is also run in `mix setup`)
  * To reset database `mix db.reset`

## Running the application
* `iex -S mix` to start with console
* `mix run --no-halt` to start without console

## Running test
* `mix lint` to run code linter
* `mix test` to run tests
* `mix test --cover` to run tests and get coverage report
* `mix coveralls --umbrella` to get coverage for whole project

## Creating release build
* `MIX_ENV=prod mix release` to build release

## Continuous integration
Currently our CI runs these tests:
* `mix lint`
* `mix test --cover`
* `mix release --warnings-as-errors`
These tests need to pass before merge request can be accepted!

