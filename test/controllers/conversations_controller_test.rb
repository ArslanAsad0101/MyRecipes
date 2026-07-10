require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @chef_one = Chef.create!(name: "Alice", email: "alice@example.com", password: "password")
    @chef_two = Chef.create!(name: "Bob", email: "bob@example.com", password: "password")
    @chef_three = Chef.create!(name: "Carol", email: "carol@example.com", password: "password")
  end

  test "logged in chef can create a conversation with another chef" do
    post chef_login_path, params: { chef: { email: @chef_one.email, password: "password" } }

    assert_response :redirect
    assert_equal @chef_one.id, session[:chef_id]

    post conversations_path, params: { chef_id: @chef_two.id }

    assert_response :redirect
    conversation = Conversation.last
    assert_not_nil conversation
    assert_equal [@chef_one.id, @chef_two.id].sort, [conversation.chef_a_id, conversation.chef_b_id].sort
  end

  test "logged in chef can send a message to a conversation" do
    post chef_login_path, params: { chef: { email: @chef_one.email, password: "password" } }

    post conversations_path, params: { chef_id: @chef_two.id }
    conversation = Conversation.last

    post conversation_messages_path(conversation), params: { message: { body: "Hello there" } }, headers: { "ACCEPT" => "application/json" }

    assert_response :success
    assert_equal 1, conversation.messages.count
    assert_equal "Hello there", conversation.messages.last.body
  end

  test "logged in chef sees a friendly forbidden page for an inaccessible conversation" do
    post chef_login_path, params: { chef: { email: @chef_one.email, password: "password" } }

    conversation = Conversation.create!(chef_a: @chef_two, chef_b: @chef_three)

    get conversation_path(conversation)

    assert_response :forbidden
    assert_includes response.body, "You are not allowed to access this conversation."
  end
end
