import Config

config :elidactyl, :pterodactyl_url, System.get_env("PTERODACTYL_URL")
config :elidactyl, :pterodactyl_auth_token,  System.get_env("PTERODACTYL_AUTH_TOKEN")
