defmodule FirestormWeb.Web.Session do
  @moduledoc """
  Some helpers for session-related things
  """

  alias FirestormWeb.Forums

  # If the conn contains an assign of current user return that user
  def current_user(%{assigns: %{current_user: u}}), do: u
  # otherwise fetch the user from the db
  def current_user(conn) do
    case get_current_user(conn) do
      nil ->
        nil

      id ->
        Forums.get_user!(id)
    end
  end

  def logged_in?(conn), do: !!current_user(conn)

  # NOTE: This exists primarily to aid in acceptance tests. We can trivially set
  # cookies in Wallaby, and this makes things easier in tests since logging in
  # via OAuth is remarkably not-easy.
  defp get_current_user(conn) do
    if get_session_from_cookies() do
      case conn.cookies["current_user"] do
        nil -> Plug.Conn.get_session(conn, :current_user)
        u -> u
      end
    else
      Plug.Conn.get_session(conn, :current_user)
    end
  end

  defp get_session_from_cookies() do
    Application.get_env(:firestorm_web, :get_session_from_cookies) || false
  end
end
