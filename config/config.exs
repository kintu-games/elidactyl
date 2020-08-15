import Config

config :elidactyl, :pterodactyl_url, "localhost"
config :elidactyl, :pterodactyl_server_auth_token, "kts6G70izhPuTfmpt8FHry93FSet63OAJ9F8mwLGvfKqKJ5l"
config :elidactyl, :pterodactyl_client_auth_token, "SrMI9WWnS5Aq6OPQKHa4Pc5Q21YkVTohCyfjZVW2847XXdXj"

# Configure your databases
config :elidactyl, Elidactyl.PanelRepo,
       username: "ptero",
       password: "pterodbpass",
       database: "pterodactyl",
       hostname: "localhost",
       pool_size: 10

import_config "#{Mix.env()}.exs"
