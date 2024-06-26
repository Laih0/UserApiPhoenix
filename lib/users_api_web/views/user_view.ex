defmodule UsersApiWeb.UserView do
  use UsersApiWeb, :view
  alias UsersApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, adress: user.adress, email: user.email, role: user.role}
  end
end
