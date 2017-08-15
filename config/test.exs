use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :firestorm_web, FirestormWeb.Web.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :firestorm_web, FirestormWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "firestorm_web_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :firestorm_web, sql_sandbox: true

config :firestorm_web, FirestormWeb.Mailer,
  adapter: Bamboo.TestAdapter

config :wallaby, screenshot_on_failure: true

# Configuration for AWS integration
config :firestorm_web, :aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  bucket: System.get_env("AWS_S3_BUCKET"),
  region: System.get_env("AWS_S3_REGION")
