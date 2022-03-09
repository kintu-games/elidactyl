import Config

config :elidactyl, :pterodactyl_url, System.get_env("PTERODACTYL_URL")
config :elidactyl, :pterodactyl_server_auth_token, System.get_env("PTERODACTYL_SERVER_AUTH_TOKEN")
config :elidactyl, :pterodactyl_client_auth_token, System.get_env("PTERODACTYL_CLIENT_AUTH_TOKEN")

import_config "prod.secret.exs"
