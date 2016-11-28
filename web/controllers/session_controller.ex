defmodule Volt.SessionController do
  use Volt.Web, :controller

  alias Volt.User
  alias Volt.Plugs.Auth

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "login.html", changeset: changeset
  end

  def create(conn, %{"user" => %{"email" => email, "password" => pass}}) do

    case Auth.validate_password(conn, email, pass) do
      {:ok, conn} ->
        conn
        |> IO.inspect
        |> put_flash(:info, "Welcome back")
        |> redirect(to: page_path(conn, :index))
      _ ->
        changeset = User.changeset(%User{}, %{"email" => email, "password" => pass})
        render conn, "login.html", changeset: %{changeset | action: :insert}
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout
    |> redirect(to: page_path(conn, :index))
  end

end
