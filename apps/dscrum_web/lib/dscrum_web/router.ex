defmodule DscrumWeb.Router do
  use DscrumWeb, :router

  alias Dscrum.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_token
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

    get "/get_user_without_team", UserController, :get_users_without_team
    put "/add_user_team", TeamController, :add_user_team
    post "/add_user_team", TeamController, :add_user_team
    put "/delete_user_team", TeamController, :delete_user_team
    put "/team", TeamController, :create

    resources "/user", UserController, only: [:index, :show, :new, :create, :edit, :update, :delete]
    resources "/team", TeamController, only: [:index, :show, :new, :create, :edit, :update, :delete]
  end

  # Other scopes may use custom stacks.
  scope "/api", DscrumWeb do
    pipe_through :api

    post "/signup", UserController, :signup
    post "/auth", UserController, :login
    get "/user-image", UserController, :image
    # get "/team-image", TeamController, :image
    get "/team-image", UserController, :image_team
    get "/difficulty-image", DifficultyController, :image
    get "/mind-state-image", MindStateController, :image
  end

  scope "/api", DscrumWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/user", UserController, :show

  end

  def fetch_token(conn, _) do
    conn
    |> assign(:token, get_session(conn, :token))
  end
end
