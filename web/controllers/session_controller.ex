defmodule Volt.SessionController do
  use Volt.Web, :controller

  def login(conn, _params) do
    render conn, "login.html"
  end
end
