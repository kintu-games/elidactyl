defmodule Elidactyl.PanelRepo do
  @moduledoc false

  use Ecto.Repo,
      otp_app: :elidactyl,
      adapter: Ecto.Adapters.MyXQL
end