defmodule Spamzapper.Forum do
  @moduledoc """
  The Forum context.
  """

  import Ecto.Query, warn: false
  alias Spamzapper.ForumRepo

  alias Spamzapper.Forum.Ban
  alias Spamzapper.Forum.Member

  @doc """
  Returns a list of domains used in email addresses.

  ## Examples

      iex> list_email_domains()
      [%EmailDomain{}, ...]

  """
  def list_email_domains do
    from(m in Member)
    |> select([m, b], %{
      email_domain: fragment("SUBSTRING_INDEX(?, '@', -1) AS email_domain", m.user_email),
      occurrences: fragment("COUNT(*) AS occurrences"),
      ban_email: b.ban_email,
    })
    |> join(:left, [m], b in Ban,
      on: fragment("? = CONCAT('*@', SUBSTRING_INDEX(?, '@', -1))", b.ban_email, m.user_email))
    |> group_by([m], fragment("email_domain"))
    |> order_by([desc: fragment("occurrences")])
    |> ForumRepo.all()
  end

  @doc """
  Gets the first matching ban entry for an email domain.

  ## Examples

      iex> get_email_ban(hotmail.com)
      %Ban{}

      iex> get_email_ban(hotmale.com)
      nil

  """
  def get_email_ban(domain) do
    filter = "*@#{domain}"

    Ban
    |> where(ban_email: ^filter)
    |> first |> ForumRepo.one
  end

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_members do
    ForumRepo.all(Member)
  end

  @doc """
  Returns a list of members filtered by email domain

  @@ Examples

      iex> list_members_by_email_domain()
      [%Member{}, ...]

  """
  def list_members_by_email_domain(domain) do
    filter = "%@#{domain}"
    ForumRepo.all(from m in Member, where: like(m.user_email, ^filter))
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id), do: ForumRepo.get!(Member, id)

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> ForumRepo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> ForumRepo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    ForumRepo.delete(member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end
end
