defmodule FirestormWeb.Feature.CategoriesTest do
  use FirestormWeb.Web.FeatureCase, async: true
  alias FirestormWeb.Forums

  defmodule Page.CategoriesIndex do
    import Wallaby.Query

    def categories(count), do: css("ol.category-list li", count: count)
    def category_title(text), do: css("h2.title", text: text)
  end

  test "categories are listed", %{session: session} do
    import Page.CategoriesIndex
    # We'll create some categories
    {:ok, [_elixir, _elm]} = create_categories(["Elixir", "Elm"])

    # Then visit the home page, ensure they're all listed, and ensure the first
    # one has the appropriate title
    session
    |> visit("/")
    |> find(categories(2))
    |> List.first()
    |> assert_has(category_title("Elixir"))
  end

  def create_categories(titles) do
    categories =
      for title <- titles do
        {:ok, category} = Forums.create_category(%{title: title})
        category
      end
    {:ok, categories}
  end
end
