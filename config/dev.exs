import Config

# Configure your databases
config :elidactyl, Elidactyl.PanelRepo,
       username: "root",
       password: "eqyN23tKAjWUPpeG#aHP4cT@xQ",
       database: "pterodactyl",
       hostname: "localhost",
       pool_size: 10

import_config "dev.secret.exs"
