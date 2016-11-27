defmodule Volt.SessionController do
  use Volt.Web, :controller

  alias Volt.User
  alias Comeonin.Bcrypt

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "login.html", changeset: changeset
  end

  def create(conn, %{"user" => %{"email" => email, "password" => pass}}) do

    case validate_password(conn, email, pass) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back")
        |> redirect(to: page_path(conn, :index))
      _ ->
        changeset = User.changeset(%User{}, %{"email" => email, "password" => pass})
        render conn, "login.html", changeset: %{changeset | action: :insert}
    end
  end

  defp validate_password(conn, email, pass) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Bcrypt.checkpw(pass, user.password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized}
      true ->
        Bcrypt.dummy_checkpw()
        {:error, :not_found}
    end
  end

  defp login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  defp logout(conn) do
    conn
    |> configure_session(drop: true)
  end

end
