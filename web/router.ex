defmodule Volt.Router do
  use Volt.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Volt.Plugs.Auth, repo: Volt.Repo
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
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/changepwd", SessionController, :changepwd_show
    post "/changepwd", SessionController, :changepwd_update
  end

  # Other scopes may use custom stacks.
  # scope "/api", Volt do
  #   pipe_through :api
  # end
end
