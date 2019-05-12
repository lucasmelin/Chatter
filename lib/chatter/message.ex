defmodule Chatter.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Chatter.{Conversation, User, ConversationUser, Repo}

  schema "messages" do
    field :body, :string

    belongs_to :conversation, Conversation
    belongs_to :user, User

    timestamps()
  end

  def all_for_conversation(conversation) do
    Repo.all(
      from m in __MODULE__,
        where: m.conversation_id == ^conversation.id,
        order_by: [asc: m.id]
    )
  end

  def create(attrs) do
    attrs
    |> changeset()
    |> Repo.insert()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:conversation_id, :user_id, :body])
    |> validate_required([:conversation_id, :user_id, :body])
    |> validate_user_in_conversation(:user_id)
    |> foreign_key_constraint(:conversation_id)
    |> foreign_key_constraint(:user_id)
  end

  def validate_user_in_conversation(changeset, field) do
    validate_change(changeset, field, fn _, user_id ->
      case ConversationUser.find_by(%{
             conversation_id: changeset.changes[:conversation_id],
             user_id: user_id
           }) do
        nil -> [{field, "is not in the conversation"}]
        _ -> []
      end
    end)
  end
end
