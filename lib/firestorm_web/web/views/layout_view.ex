defmodule FirestormWeb.Web.Layout.PageTitle do
  alias FirestormWeb.Web.{CategoryView, ThreadView, UserView}
  @app_name "Firestorm"

  def for({view, action, assigns}) do
    {view, action, assigns}
    |> get()
    |> add_app_name()
  end

  defp get({CategoryView, :index, _}) do
    "Categories"
  end
  defp get({CategoryView, :show, %{category: category}}) do
    category.title
  end
  defp get({CategoryView, :new, _}) do
    "New Category"
  end
  defp get({CategoryView, :edit, %{category: category}}) do
    "Edit #{category.title}"
  end
  defp get({ThreadView, :show, %{thread: thread, category: category}}) do
    "#{thread.title} - #{category.title}"
  end
  defp get({ThreadView, :new, %{category: category}}) do
    "New Thread - #{category.title}"
  end
  defp get({ThreadView, :edit, %{thread: thread}}) do
    "Edit #{thread.title}"
  end
  defp get({UserView, :show, %{user: user}}) do
    "#{user.username} - Users"
  end
  defp get({_, _, _}), do: nil

  defp add_app_name(nil), do: @app_name
  defp add_app_name(title), do: "#{title} - #{@app_name}"
end

defmodule FirestormWeb.Web.LayoutView do
  use FirestormWeb.Web, :view
  alias FirestormWeb.Web.Layout.PageTitle

  def page_title(conn) do
    view = view_module(conn)
    action = action_name(conn)
    PageTitle.for({view, action, conn.assigns})
  end

  def js_script_tag do
    if Mix.env == :prod do
      # In production we'll just reference the file
      "<script src=\"/js/app.js\"></script>"
    else
      # In development mode we'll load it from our webpack dev server
      "<script src=\"http://localhost:8080/js/app.js\"></script>"
    end
  end

  # Ditto for the css
  def css_link_tag do
    if Mix.env == :prod do
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/app.css\" />"
    else
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://localhost:8080/css/app.css\" />"
    end
  end
end
