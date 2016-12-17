defmodule Volt.SessoionControllerTest do
  use Volt.ConnCase
  #import Logger

  @valid_attrs %{email: "x@y.com", password: "some content", password_confirmation: "some content"}
  @invalid_attrs %{email: "x@y.com", password: "wrong", password_confirmation: "wrong"}
  @chgpwd_attrs %{old_password: "some content", password: "121212", password_confirmation: "121212"}
  @invalid_chgpwd_attrs %{old_password: "some content", password: "121212", password_confirmation: "invalid"}


  setup %{conn: conn} = config do
    if config[:logged_out] do
      {:ok, conn: conn}
    else
      user = insert_user(@valid_attrs)
      conn = build_conn()
      # Login a user
      conn = post(conn, session_path(conn, :create, user: @valid_attrs))
      {:ok, conn: conn, user: user}
    end
  end

  @tag :logged_out
  test "new session presents login page",
      %{conn: conn} do
      conn = get(conn, session_path(conn, :new))
      assert html_response(conn, 200) =~ "Login"
  end

  test "successful login redirects to page_path",
      %{conn: conn, user: user} do

      #setup function already logs a user in
      # check if the userID is valid
      assert user.id == conn.assigns.current_user.id
      assert redirected_to(conn) == page_path(conn, :index)
  end

  @tag :logged_out
  test "invalid data renders login page again",
      %{conn: conn} do

      conn = post(conn, session_path(conn, :create, user: @invalid_attrs))
      assert html_response(conn, 200) =~ "Login"
  end

  @tag :logged_out
  test "delete session logs out the user correctly",
      %{conn: conn} do

      conn = delete conn, session_path(conn, :delete, "123")
      assert redirected_to(conn) == page_path(conn, :index)
  end

  @tag :logged_out
  test "changepwd without logged in user route redirects",
    %{conn: conn} do
     conn = get conn, session_path(conn, :changepwd_show)
     assert html_response(conn, 302)
     assert redirected_to(conn) == page_path(conn, :index)
  end

  test "changepwd with logged in user route presents the change password page",
    %{conn: conn, user: _user} do

    conn = get conn, session_path(conn, :changepwd_show)
    assert html_response(conn, 200) =~ "Change Password"
  end

  test "successful change password redirects to page_path",
    %{conn: conn, user: _user} do
    conn = post(conn, session_path(conn, :changepwd_update, changepwd: @chgpwd_attrs))

    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "change password with invalid_attrs presents changepwd_show",
    %{conn: conn, user: _user} do
    conn = post(conn, session_path(conn, :changepwd_update, changepwd: @invalid_chgpwd_attrs))
    assert html_response(conn, 200) =~ "Change Password"
  end

end
