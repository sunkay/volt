defmodule Volt.PageControllerTest do
  use Volt.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Volt!"
  end
end
