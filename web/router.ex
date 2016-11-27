defmodule Volt.Router do
  use Volt.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/manage", Volt do
    pipe_through :browser # Use the default browser stack

    resources "/users", UserController
  end


  scope "/", Volt do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", SessionController, :login
  end

  # Other scopes may use custom stacks.
  # scope "/api", Volt do
  #   pipe_through :api
  # end
end
