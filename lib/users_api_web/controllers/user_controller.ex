defmodule UsersApiWeb.UserController do
  use UsersApiWeb, :controller
  use PhoenixSwagger
  import Plug.Conn.Status, only: [code: 1]
  alias UsersApi.Admin
  alias UsersApi.Admin.User

  action_fallback UsersApiWeb.FallbackController

  swagger_path :index do
    get("/api/users")
    description("List of users")
    response(code(:ok), "Success")
  end

  def show(conn, %{"id" => id}) do
    IO.inspect(id)
    user = Admin.get_user!(id)
    render(conn, "show.json", user: user)
  end

  swagger_path :show do
    get("/api/users/{id}")
    description("Afficher un utilisateur")

    parameters do
      path_param(:id, :binary_id, "ID de l'utilisateur")
    end

    response(code(:ok), "Succès")
  end

  swagger_path :create do
    post("/api/users")
    description("Créer un utilisateur")
    response(code(:created), "Créé")
  end

  swagger_path :update_patch do
    patch("/api/users/:id")
    description("Mettre à jour un utilisateur (PATCH)")
    response(code(:ok), "Succès")
  end

  swagger_path :update do
    put("/api/users/:id")
    description("Mettre à jour un utilisateur (PUT)")
    response(code(:ok), "Succès")
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/users/:id")
    description("Supprimer un utilisateur")
    response(code(:no_content), "Aucun contenu")
  end

  def index(conn, _params) do
    users = Admin.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Admin.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   user = Admin.get_user!(id)
  #   render(conn, "show.json", user: user)
  # end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Admin.get_user!(id)

    with {:ok, %User{} = user} <- Admin.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Admin.get_user!(id)

    with {:ok, %User{}} <- Admin.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
