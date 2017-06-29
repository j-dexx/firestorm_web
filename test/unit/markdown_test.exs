defmodule FirestormWeb.MarkdownTest do
  use ExUnit.Case
  alias FirestormWeb.Markdown

  test "renders basic things" do
    assert "<p>foo</p>\n" == Markdown.render("foo")
  end

  test "renders Github Flavoured Markdown blocks with our preferred code class prefix" do
    # We'll introduce an example block of markdown
    markdown =
      """
      Here's some Elixir code:

      ```elixir
      defmodule Foo do
        def bar, do: "baz"
      end
      ```
      """

    # As it stands, I'm not sure what this will look like - I'll put in some
    # known-bad value and then run the test and replace it with the result, if
    # it seems reasonable.
    expected =
      """
      <p>Here’s some Elixir code:</p>
      <pre><code class=\"elixir language-elixir\">defmodule Foo do
        def bar, do: &quot;baz&quot;
      end</code></pre>
      """

    assert expected == Markdown.render(markdown)
  end

  test "autolinks URLs" do
    assert "<p><a href=\"http://slashdot.org\">http://slashdot.org</a></p>\n" == Markdown.render("http://slashdot.org")
  end

  test "converts words like :poop: into their emoji unicode representation" do
    poop = Exmoji.from_short_name("poop") |> Exmoji.EmojiChar.render
    fire = Exmoji.from_short_name("fire") |> Exmoji.EmojiChar.render
    input = "This :poop::fire: is great!"
    output = "<p>This #{poop}#{fire} is great!</p>\n"
    assert output == Markdown.render(input)
  end
end
