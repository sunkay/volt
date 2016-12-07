defmodule Volt.SessoionControllerTest do
  use Volt.ConnCase

  @valid_attrs %{email: "x@y.com", password: "some content", password_confirmation: "some content"}
  @invalid_attrs %{email: "x@y.com", password: "wrong", password_confirmation: "wrong"}

  test "new session presents login page",
      %{conn: conn} do
      conn = get(conn, session_path(conn, :new))
      assert html_response(conn, 200) =~ "Login"
  end

  test "successful login redirects to page_path",
      %{conn: conn} do

      _ = insert_user(@valid_attrs)

      conn = post(conn, session_path(conn, :create, user: @valid_attrs))
      assert redirected_to(conn) == page_path(conn, :index)
  end

  test "invalid data renders login page again",
      %{conn: conn} do

      _ = insert_user(@valid_attrs)

      conn = post(conn, session_path(conn, :create, user: @invalid_attrs))
      assert html_response(conn, 200) =~ "Login"
  end

  test "delete session logs out the user correctly",
      %{conn: conn} do

      conn = delete conn, session_path(conn, :delete, "123")
      assert redirected_to(conn) == page_path(conn, :index)
  end

end
