defmodule Volt.AuthTest do
  use Volt.ConnCase

  alias Volt.Plugs.Auth
  alias Volt.Repo

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Volt.Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end


  test "login has the correct id in the session", %{conn: conn} do
    user = insert_user(email: "x@y.com")
    login_conn =
      conn
      |> Auth.login(user)
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == user.id
  end

  test "connection has no user in the session after logout",
      %{conn: conn} do
    logout_conn =
      conn
      |> put_session(:user_id, 123)
      |> Auth.logout
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  test "call gets user from repo and inserts into :current_user assigns",
      %{conn: conn} do
    user = insert_user(email: "x@y.com")

    conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Repo)

    assert conn.assigns.current_user.id == user.id
    assert conn.assigns.current_user.email == "x@y.com"
  end

  test "call assigns nil when user_id is not set ",
      %{conn: conn} do

    conn =
      conn
      |> put_session(:user_id, nil)
      |> Auth.call(Repo)

    refute conn.assigns.current_user
  end

  test "validate password has a valid user in assigns current_user",
      %{conn: conn} do

    _ = insert_user(email: "x@y.com", password: "secret")

    {:ok, conn} = Auth.validate_password(conn, "x@y.com", "secret")
    assert conn.assigns.current_user.email == "x@y.com"
  end

  test "validate_password returns unauthorized if validation fails",
      %{conn: conn} do

    _ = insert_user(email: "x@y.com", password: "secret")

    {:error, :unauthorized} = Auth.validate_password(conn, "x@y.com", "wrong")
    refute conn.assigns.current_user
  end

  test "validate_password returns not_found if user not found",
      %{conn: conn} do

    {:error, :not_found} = Auth.validate_password(conn, "x@y.com", "wrong")
    refute conn.assigns.current_user
  end

  test "RequireAuth Plug halts connection if current_user is nil",
      %{conn: conn} do

      conn =
        conn
        |> Volt.Plugs.RequireAuth.call("123")

      refute conn.assigns.current_user
  end

  test "RequireAuth Plug returns connection if current_user is set",
      %{conn: conn} do

      conn =
        conn
        |> assign(:current_user, insert_user(email: "x@y.com"))
        |> Volt.Plugs.RequireAuth.call("123")

      assert conn.assigns.current_user.email == "x@y.com"
  end


end
