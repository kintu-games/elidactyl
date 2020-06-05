use Mix.Config

config :elidactyl, :pterodactyl_url, "localhost:8081"
config :elidactyl, :pterodactyl_auth_token, "asdf"

# Configure your database
config :elidactyl, Pterodactyl.PanelRepo,
       username: "root",
       password: "eqyN23tKAjWUPpeG#aHP4cT@xQ",
       database: "pterodactyl",
       hostname: "localhost",
       pool_size: 10