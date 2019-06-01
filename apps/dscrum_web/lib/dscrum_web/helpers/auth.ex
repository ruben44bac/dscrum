defmodule DscrumWeb.Helpers.Auth do

  alias Dscrum.UserSchema
  alias Dscrum.Repo

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: !!Repo.get(UserSchema, user_id)
  end

end
