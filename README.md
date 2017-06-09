<p align="center">
    <img src="https://cdn.rawgit.com/osasto-kuikka/KGE/master/extras/logo.svg" width="480">
</p>

<p align="center">
    <a href="https://travis-ci.org/osasto-kuikka/kuikka-website">
        <img src="https://img.shields.io/travis/osasto-kuikka/kuikka-website.svg?style=flat-square&label=Build" alt="Build Status">
    </a>
    <a href='https://coveralls.io/github/osasto-kuikka/kuikka-website?branch=master'>
      <img src='https://coveralls.io/repos/github/osasto-kuikka/kuikka-website/badge.svg?branch=master' alt='Coverage Status' />
    </a>
    <a href="https://github.com/osasto-kuikka/kuikka-website/issues">
        <img src="https://img.shields.io/github/issues-raw/osasto-kuikka/kuikka-website.svg?style=flat-square&label=Issues" alt="Issues">
    </a>
    <a href="https://github.com/osasto-kuikka/kuikka-website/blob/master/LICENSE">
        <img src="https://img.shields.io/badge/License-GPLv2-red.svg?style=flat-square" alt="License">
    </a>
</p>

## Setup Development environment
Required:
* [Erlang 19.2](http://www.erlang.org/)
* [Elixir 1.4.4](http://elixir-lang.org/)
* [Nodejs 6.9](https://nodejs.org/en/)
* [Postgresql 9.5](https://www.postgresql.org/)

### Windows
Install with [Chocolatey](https://chocolatey.org/install)
```
choco install -y erlang elixir nodejs VisualCppBuildTools
```
Postgresql needs to be installed separately as chocolatey repository
does not have 9.5 version!

### Linux
* Arch
  * `pacman -S install erlang elixir nodejs postgresql`
* Fedora 25
  * `dnf install -y erlang nodejs postgresql-server`
  * Elixir 1.4.4 needs to be installed separatele as fedora
    repository only has 1.3.1 which is not supported

### Project setup
```
mix setup (Setup everything with one command)
mix setup.min (Get dependencies and compile)
mix npm.install (Install npm packages to frontend)
mix npm.build (Build minified javascript)
mix ecto.setup (Setup database)
mix ecto.reset (Reset database)
```

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
