defmodule Elidactyl.Servers.Subusers do
  @moduledoc """
  Module allows to modify server's subusers.
  """

  alias Elidactyl.PanelRepo, as: Repo
  alias Elidactyl.Schemas.User
  alias Elidactyl.Schemas.Server
  alias Elidactyl.Schemas.Server.Subuser
  alias Elidactyl.Schemas.Server.Subuser.Permission
  alias Ecto.Multi

  import Ecto.Query, only: [from: 2]

  def assign_subuser(%Server{} = server, %User{} = user) do
    case query_subuser(server, user) do
      %Subuser{} = existing_subuser -> {:ok, existing_subuser}
      nil ->
        {:ok, new_subuser} =
          %Subuser{}
            |> Subuser.changeset(%{user_id: user.id, server_id: server.id})
            |> Repo.insert()

        set_all_permissions(new_subuser)
      {:ok, new_subuser}
    end
  end

  def revoke_subuser(%Subuser{} = subuser) do
    case query_subuser(subuser) do
      nil ->
        :ok
      _ ->
        reset_permissions(subuser)
        Repo.delete(subuser)
        :ok
    end
  end

  defp query_subuser(%Subuser{id: id}), do: Repo.get(Subuser, id)
  defp query_subuser(%Server{} = server, %User{} = user) do
#    Repo.get(from(s in Subuser, where: s.user_id == ^user.id and s.server_id == ^server.id))
    Repo.get_by(Subuser, user_id: user.id, server_id: server.id)
  end

  defp set_all_permissions(subuser) do
    multi_cleanup =
      Multi.delete_all(Multi.new(), :delete_all,
        from(p in Permission, where: p.subuser_id == ^subuser.id))

    multi_inserts =
      Enum.reduce(all_permissions(), multi_cleanup, fn permission, multi_acc ->
        Multi.insert(multi_acc, permission, Permission.changeset(%Permission{},
          %{subuser_id: subuser.id, permission: permission}))
      end)

    Repo.transaction(multi_inserts)
  end

  defp reset_permissions(subuser) do
    Multi.new()
    |> Multi.delete_all(:delete_all,
         from(p in Permission, where: p.subuser_id == ^subuser.id))
    |> Repo.transaction()
  end

  defp all_permissions() do
    [
      "power-start",
      "power-stop",
      "power-kill",
      "power-restart",

      "send-command",

      "list-subusers",
      "view-subusers",
      "edit-subusers",
      "create-subusers",
      "delete-subusers",

      "view-allocations",
      "edit-allocation",

      "view-startup",
      "edit-startup",

      "view-databases",
      "reset-db-password",
      "delete-database",
      "create-database",

      "access-sftp",
      "list-files",
      "edit-files",
      "save-files",
      "move-files",
      "copy-files",
      "compress-files",
      "decompress-files",
      "create-files",
      "upload-files",
      "delete-files",
      "download-files",

      "list-schedules",
      "view-schedules",
      "toggle-schedules",
      "queue-schedules",
      "edit-schedules",
      "create-schedules",
      "delete-schedules"
    ]
  end
end