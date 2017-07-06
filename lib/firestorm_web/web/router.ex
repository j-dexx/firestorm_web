defmodule FirestormWeb.Web.Router do
  use FirestormWeb.Web, :router

  pipeline :browser do
    plug Ueberauth
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug FirestormWeb.Web.Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # We also need to add the Ueberauth routes. This will set up the redirect and
  # callback for our OAuth provider steps
  scope "/auth", FirestormWeb.Web do
    pipe_through :browser

    delete "/logout", AuthController, :delete
    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", FirestormWeb.Web do
    pipe_through :browser # Use the default browser stack

    get "/", CategoryController, :index
    resources "/users", UserController
    resources "/categories", CategoryController do
      resources "/threads", ThreadController do
        resources "/posts", PostController, only: [:new, :create]
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", FirestormWeb.Web do
  #   pipe_through :api
  # end
end
