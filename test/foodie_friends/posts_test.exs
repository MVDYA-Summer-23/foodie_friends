defmodule FoodieFriends.PostsTest do
  use FoodieFriends.DataCase

  alias FoodieFriends.Posts

  describe "posts" do
    alias FoodieFriends.Posts.Post
    alias FoodieFriends.Comments.Comment

    import FoodieFriends.PostsFixtures
    import FoodieFriends.CommentsFixtures
    import FoodieFriends.AccountsFixtures

    @invalid_attrs %{content: nil, subtitle: nil, title: nil}

    test "list_posts/0 returns all posts" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert Posts.list_posts() == [post]
    end

    test "list_posts/0 returns all posts by newest to oldest" do
      user = user_fixture()
      newest_post = post_fixture(user_id: user.id)

      {:ok, oldest_post} =
        %{
          content: "some other content",
          title: "another title",
          published_on: DateTime.utc_now() |> DateTime.add(-1, :day),
          visible: true,
          user_id: user.id
        }
        |> Posts.create_post()

      assert Posts.list_posts() == [newest_post, oldest_post]
    end

    test "list_posts/0 returns only visible posts" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      {:ok, _invisible_post} =
        %{
          content: "some other content",
          title: "invisible title",
          published_on: DateTime.utc_now(),
          visible: false,
          user_id: user.id
        }
        |> Posts.create_post()

      assert Posts.list_posts() == [post]
    end

    test "list_posts/0 returns only posts published before now (date/time)" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      {:ok, _future_post} =
        %{
          content: "future post content",
          title: "future post title",
          published_on: DateTime.utc_now() |> DateTime.add(1, :day),
          visible: true,
          user_id: user.id
        }
        |> Posts.create_post()

      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 with a given post id returns the post, without regard for other preloaded fields" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      fetched_post = Posts.get_post!(post.id)
      assert Map.delete(fetched_post, :comments) == Map.delete(fetched_post, :comments)
    end

    # TODO: create test "get_post!/1 returns the post with given, its author's username, and associated comments"
    test "get_post!/1 returns the post with given id and comments" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      comment = comment_fixture(post_id: post.id, user_id: user.id)

      fetched_post = Posts.get_post!(post.id)

      assert fetched_post.user == user
      assert [fetched_comment] = fetched_post.comments
      assert Map.delete(fetched_comment, :user) == Map.delete(comment, :user)
      assert fetched_comment.user == user
    end

    test "create_post/1 with valid data creates a post" do
      now = DateTime.utc_now()
      user = user_fixture()

      valid_attrs = %{
        user_id: user.id,
        content: "some created content",
        title: "some created title",
        published_on: now
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some created content"
      assert post.title == "some created title"
      assert DateTime.to_unix(post.published_on) == DateTime.to_unix(now)
    end

    test "create_post/1 uses the appropriate datetime for the published_on field" do
      user = user_fixture()

      valid_attrs = %{
        "content" => "I want mexican food",
        "published_on" => "2023-07-26T20:41",
        "title" => "New title",
        "visible" => "false",
        "user_id" => "#{user.id}"
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.published_on == ~U[2023-07-26 20:41:00Z]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      update_attrs = %{
        content: "some updated content",
        subtitle: "some updated subtitle",
        title: "some updated title"
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
    end

    test "delete_post/1 deletes the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end

    test "search/1 pulls the post based off of input" do
      user = user_fixture()
      post = post_fixture(title: "burger", user_id: user.id)
      post1 = post_fixture(title: "ice-cream", user_id: user.id)
      post2 = post_fixture(title: "bacon cheeseburger", user_id: user.id)

      assert Posts.search("burger") == [post, post2]
      assert Posts.search("Bur") == [post, post2]
      assert Posts.search("BuRger") == [post, post2]
      assert Posts.search("BURGER") == [post, post2]
      assert Posts.search("") == [post, post1, post2]
      refute Posts.search("burger") == [post1]
    end
  end
end
