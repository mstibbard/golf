defmodule GolfWeb.Router do
  use GolfWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Golf.Plugs.SetUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/manage", GolfWeb do
    pipe_through([:browser, :authenticate_user])

    resources("/players", PlayerController)
    get("/print", PageController, :print)
    resources("/games", GameController)
    resources "/games/score", ScoreController, except: [:new]
    get("/games/score/new/:id", ScoreController, :new)
    post("/games/score/create_many", ScoreController, :create_many)
  end

  scope "/auth", GolfWeb do
    pipe_through(:browser)

    get("/signout", AuthController, :delete)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :new)
  end

  scope "/", GolfWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end
end
