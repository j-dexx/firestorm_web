# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :firestorm_web,
  ecto_repos: [FirestormWeb.Repo]

# Configures the endpoint
config :firestorm_web, FirestormWeb.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AijXfgJILpHTNsOlCkhPA6vYQoxeyKs+OgjiR741OModTY0aJxCDeaH8N1F4V0C7",
  render_errors: [view: FirestormWeb.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FirestormWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure :ueberauth
config :ueberauth, Ueberauth,
  providers: [
    # We don't need any permissions on GitHub as we're just using it as an
    # identity provider, so we'll set an empty default scope.
    github: {Ueberauth.Strategy.Github, [default_scope: ""]}
  ]

# We also need a github client id and secret. I've already generated an
# application on github and I've stored these secrets somewhere...secret.
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
