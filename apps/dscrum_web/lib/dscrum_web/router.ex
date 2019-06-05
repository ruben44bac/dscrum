defmodule DscrumWeb.Router do
  use DscrumWeb, :router

  alias Dscrum.Guardian

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

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/", DscrumWeb do
    pipe_through :browser

    # get "/", PageController, :index
    get "/", TeamController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete


    put "/add_user_team", TeamController, :add_user_team

    resources "/user", UserController, only: [:index, :show, :new, :create, :edit, :update, :delete]
    resources "/team", TeamController, only: [:index, :show, :new, :create, :edit, :update, :delete]
  end

  # Other scopes may use custom stacks.
  scope "/api", DscrumWeb do
    pipe_through :api

    post "/signup", UserController, :signup
    post "/auth", UserController, :login
    get "/user-image", UserController, :image
    get "/team-image", TeamController, :image
  end

  scope "/api", DscrumWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/user", UserController, :show

  end
end
