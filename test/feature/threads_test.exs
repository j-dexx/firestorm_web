defmodule FirestormWeb.Feature.ThreadsTest do
  use FirestormWeb.Web.FeatureCase, async: true
  alias FirestormWeb.Forums

  test "creating a new thread", %{session: session} do
    import Page.Thread.{New, Show}
    import Page.Category.Show
    {:ok, [elixir]} = create_categories(["Elixir"])
    {:ok, user} = Forums.create_user(%{username: "knewter", email: "josh@dailydrip.com", name: "Josh Adams"})

    session
    |> log_in_as(user)
    |> visit(category_path(FirestormWeb.Web.Endpoint, :show, elixir))
    |> click(new_thread_link())
    |> fill_in(title_field(), with: "OTP is cool")
    |> fill_in(body_field(), with: "Don't you think?")
    |> click(create_thread_button())
    |> assert_has(thread_title("OTP is cool"))
    |> Browser.take_screenshot()
  end

  # We'll move this to a factories helper at some point
  def create_categories(titles) do
    categories =
      for title <- titles do
        {:ok, category} = Forums.create_category(%{title: title})
        category
      end
    {:ok, categories}
  end

  defp log_in_as(session, user) do
    session
    |> visit("/")
    |> Browser.set_cookie("current_user", user.id)
  end
end
