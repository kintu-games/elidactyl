import Config

config :elidactyl, :pterodactyl_url, "localhost"
config :elidactyl, :pterodactyl_server_auth_token, "7lBvLFONZEGFkiIE7VEynjkvH5ruRVJmt40gQHZSUwyv9ecN"
config :elidactyl, :pterodactyl_client_auth_token, "i3m16iH0sl5NA8MxHHH4hTK3iNB094QVR8VsNKk86umiiMEH"

config :ecto, json_library: Jason

import_config "#{Mix.env()}.exs"
