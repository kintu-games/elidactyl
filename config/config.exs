import Config

config :elidactyl, :pterodactyl_url, "localhost"
config :elidactyl, :pterodactyl_auth_token, "kts6G70izhPuTfmpt8FHry93FSet63OAJ9F8mwLGvfKqKJ5l"

# Configure your databases
config :elidactyl, Elidactyl.PanelRepo,
       username: "ptero",
       password: "pterodbpass",
       database: "pterodactyl",
       hostname: "localhost",
       pool_size: 10

import_config "#{Mix.env()}.exs"
