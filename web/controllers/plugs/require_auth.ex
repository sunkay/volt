defmodule Volt.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Volt.Router.Helpers

  def init(_opts) do
  end

  def call(conn, _) do
    cond do
      conn.assigns.current_user == nil ->
        conn
        |> put_flash(:error, "Not authorized. Login to view this page")
        |> redirect(to: Helpers.page_path(conn, :index))
        |> halt()
      true ->
        conn
    end
  end

end
