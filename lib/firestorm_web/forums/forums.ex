defmodule FirestormWeb.Forums do
  @moduledoc """
  The boundary for the Forums system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Ecto.Multi
  alias FirestormWeb.Repo

  alias FirestormWeb.Forums.{User, Category, Thread, Post}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_username(username), do: Repo.get_by(User, %{username: username})

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :name])
    |> validate_required([:username, :email, :name])
    |> unique_constraint(:username)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> category_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> category_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    category_changeset(category, %{})
  end

  defp category_changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

  @doc """
  Returns the list of threads.

  ## Examples

      iex> list_threads(category)
      [%Thread{}, ...]

  """
  def list_threads(category) do
    Thread
    |> where([t], t.category_id == ^category.id)
    |> Repo.all
  end

  @doc """
  Gets a single thread.

  Raises `Ecto.NoResultsError` if the Thread does not exist.

  ## Examples

      iex> get_thread!(category, 123)
      %Thread{}

      iex> get_thread!(category, 456)
      ** (Ecto.NoResultsError)

  """
  def get_thread!(category, id) do
    Thread
    |> where([t], t.category_id == ^category.id)
    |> Repo.get!(id)
  end

  @doc """
  Creates a thread.

  ## Examples

      iex> create_thread(category, user, %{field: value, body: "some body"})
      {:ok, {%Thread{}, %Post{}}}

      iex> create_thread(category, user, %{field: bad_value})
      {:error, :thread, %Ecto.Changeset{}}

  """
  def create_thread(category, user, attrs \\ %{}) do
    # We'll build as much of the post attributes we can for now - everything but
    # the thread id
    post_attrs =
      attrs
      |> Map.take([:body])
      |> Map.put(:user_id, user.id)

    # We'll also build the thread attributes a bit more explicitly
    thread_attrs =
      attrs
      |> Map.take([:title])
      |> Map.put(:category_id, category.id)

    # We'll generate a thread changeset
    thread_changeset =
      %Thread{}
      |> thread_changeset(thread_attrs)

    # And we'll start a new Ecto.Multi.
    # This is a data structure that identifies the changes that we wish to make.
    # We'll run it later in a `Repo.transaction`
    multi =
      # We create a new Multi with Multi.new
      Multi.new
      # We'll insert our thread. The first argument here is the key by which we
      # can refer to this operation when we get the results or when we use
      # intermediate values mid-transaction in future `Multi` functions
      |> Multi.insert(:thread, thread_changeset)
      # Once we've inserted the thread, we'll use `Multi.run` so we can
      # reference the resulting thread to extract its id
      |> Multi.run(:post, fn %{thread: thread} ->
        # We'll add the thread_id to our post attributes
        post_attrs =
          post_attrs
          |> Map.put(:thread_id, thread.id)

        # We generate the post changeset and insert it
        post_changeset =
          %Post{}
          |> post_changeset(post_attrs)
          |> Repo.insert
      end)

    # Now we've described the transaction. All that remains is to actually run
    # the transaction. This is accomplished by passing our Multi to
    # Repo.transaction.
    case Repo.transaction(multi) do
      # if it succeeds, we'll get an ok-tuple containing the result, which is a
      # map of our keys with the result of each operation. In this case, we'll
      # have a map with a `thread` and a `post` key.
      {:ok, result} ->
        # We'll return them in a 2-tuple, which is how I decided this return
        # should look.
        {:ok, {result.thread, result.post}}
      # In the event of an error, we get a 4-tuple containing :error, the key
      # that errored, the changeset for the error, and a map of the changes that
      # have occurred so far. We'll just return the thread changeset if there
      # was an error there.
      {:error, :thread, thread_changeset, _changes_so_far} ->
        {:error, :thread, thread_changeset}
      # Ditto for the post changeset if there's an error there.
      {:error, :post, post_changeset, _changes_so_far} ->
        {:error, :post, post_changeset}
    end
  end

  @doc """
  Updates a thread.

  ## Examples

      iex> update_thread(thread, %{field: new_value})
      {:ok, %Thread{}}

      iex> update_thread(thread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread(%Thread{} = thread, attrs) do
    thread
    |> thread_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Thread.

  ## Examples

      iex> delete_thread(thread)
      {:ok, %Thread{}}

      iex> delete_thread(thread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread(%Thread{} = thread) do
    Repo.delete(thread)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread changes.

  ## Examples

      iex> change_thread(thread)
      %Ecto.Changeset{source: %Thread{}}

  """
  def change_thread(%Thread{} = thread) do
    thread_changeset(thread, %{})
  end

  defp thread_changeset(%Thread{} = thread, attrs) do
    thread
    |> cast(attrs, [:title, :category_id])
    |> validate_required([:title, :category_id])
  end

  def login_or_register_from_github(%{nickname: nickname, name: name, email: email}) do
    case get_user_by_username(nickname) do
      nil ->
        create_user(%{email: email, name: name, username: nickname})
      user ->
        {:ok, user}
    end
  end

  def create_post(%Thread{} = thread, %User{} = user, attrs) do
    attrs =
      attrs
      |> Map.put(:thread_id, thread.id)
      |> Map.put(:user_id, user.id)

    %Post{}
    |> post_changeset(attrs)
    |> Repo.insert()
  end

  defp post_changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :thread_id, :user_id])
    |> validate_required([:body, :thread_id, :user_id])
  end
end
