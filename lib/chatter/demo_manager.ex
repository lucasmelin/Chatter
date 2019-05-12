defmodule Chatter.DemoManager do
  alias Chatter.{
    DemoManager,
    Repo,
    Comment,
    Conversation,
    ConversationUser,
    Message,
    Post
  }

  def reset_and_seed_database!(force \\ false) do
    if force || System.get_env("CLEAR_DB_WEEKLY") do
      DemoManager.reset_database!()
    end
  end

  def reset_database! do
    Repo.delete_all(Comment)
    Repo.delete_all(Post)
    Repo.delete_all(Message)
    Repo.delete_all(ConversationUser)
    Repo.delete_all(Conversation)
  end
end
