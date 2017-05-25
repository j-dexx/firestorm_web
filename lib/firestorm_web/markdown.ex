defmodule FirestormWeb.Markdown do
  @moduledoc """
  Render a string as markdown in the FirestormWeb style.
  Then sanitize the resulting HTML (eventually...FIXME).
  """

  def render(body) do
    body
    |> Earmark.as_html!(earmark_options())
  end

  def earmark_options() do
    %Earmark.Options{
      code_class_prefix: "language-"
    }
  end

end
