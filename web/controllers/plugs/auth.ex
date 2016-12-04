defmodule Volt.Plugs.Auth do
  import Plug.Conn

  alias Volt.User
  alias Comeonin.Bcrypt

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        conn
      user = user_id && repo.get(Volt.User, user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def validate_password(conn, email, pass) do
    user = Volt.Repo.get_by(User, email: email)

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

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> configure_session(drop: true)
  end

end
