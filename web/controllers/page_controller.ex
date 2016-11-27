defmodule Volt.PageController do
  use Volt.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
