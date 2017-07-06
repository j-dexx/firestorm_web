defmodule Page.Post.New do
  import Wallaby.Query

  def body_field(), do: fillable_field("post_body")
  def create_post_button(), do: button("Create Post")
  def reply_button(), do: button("Reply")
end
