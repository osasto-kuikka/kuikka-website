use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"h0v>3XkWPNG*BqZoqK<fYjo@rqTf_dkiCXdg1JN!vfXDpTK|}]Q:94x.IJJVeW8c"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"#{System.get_env("KUIKKA_WEBSITE_COOKIE")}"

  set post_start_hook: "rel/hooks/post_start"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :kuikka_website do
  set version: "#{Keyword.get(KuikkaWebsite.Mixfile.project(), :version)}"
  set applications: [
    frontend: :permanent,
    kuikkadb: :permanent,
    user: :permanent
  ]
end

