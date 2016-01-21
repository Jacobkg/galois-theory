require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  def setup
    ChatEvent.clear_all
  end

  test "User enters a room" do
    post :create, {"date" => "2014-02-28T13:00Z", "user" => "Alice", "type" => "enter" }
    assert_response :success
    assert_equal JSON.parse(response.body), { "success" => "ok" }

    get :index, { from: "2014-01-01T01:00Z", to: "2015-01-01T01:00Z" }
    assert_response :success
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T13:00Z", "user" => "Alice", "type" => "enter" }]
  end

  test "User comments in a room" do
    post :create, {"date" => "2014-02-28T13:01Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}
    assert_response :success
    assert_equal JSON.parse(response.body), { "success" => "ok" }

    get :index, { from: "2014-01-01T01:00Z", to: "2015-01-01T01:00Z" }
    assert_response :success
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T13:01Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}]
  end

  test "User high-fives another user" do
    post :create, {"date" => "2014-02-28T13:02Z", "user" => "Alice", "type" => "highfive", "otheruser" => "bob"}
    assert_response :success
    assert_equal JSON.parse(response.body), { "success" => "ok" }

    get :index, { from: "2014-01-01T01:00Z", to: "2015-01-01T01:00Z" }
    assert_response :success
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T13:02Z", "user" => "Alice", "type" => "highfive", "otheruser" => "bob"}]
  end

  test "select events by date range" do
    post :create, {"date" => "2014-02-28T13:00Z", "user" => "Alice", "type" => "enter" }
    post :create, {"date" => "2014-02-28T14:00Z", "user" => "Bob", "type" => "enter" }
    post :create, {"date" => "2014-03-01T13:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}
    post :create, {"date" => "2014-03-02T13:02Z", "user" => "Alice", "type" => "highfive", "otheruser" => "bob"}
    get :index, { from: "2014-02-28T14:00Z", to: "2014-03-02T01:00Z" }
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T14:00Z", "user" => "Bob", "type" => "enter" },
                                             {"date" => "2014-03-01T13:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}]
  end

end
