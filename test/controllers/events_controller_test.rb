require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  def setup
    ChatLog.clear_all
  end

  test "User enters a room" do
    post :create, {"date" => "2014-02-28T13:00:00Z", "user" => "Alice", "type" => "enter" }
    assert_response :success
    assert_equal JSON.parse(response.body), { "success" => "ok" }

    get :index, { from: "2014-01-01T01:00:00Z", to: "2015-01-01T01:00:00Z" }
    assert_response :success
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T13:00:00Z", "user" => "Alice", "type" => "enter" }]
  end

  test "User comments in a room" do
    post :create, {"date" => "2014-02-28T13:01:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}
    assert_response :success
    assert_equal JSON.parse(response.body), { "success" => "ok" }

    get :index, { from: "2014-01-01T01:00:00Z", to: "2015-01-01T01:00:00Z" }
    assert_response :success
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T13:01:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}]
  end

  test "User high-fives another user" do
    post :create, {"date" => "2014-02-28T13:02:00Z", "user" => "Alice", "type" => "highfive", "otheruser" => "bob"}
    assert_response :success
    assert_equal JSON.parse(response.body), { "success" => "ok" }

    get :index, { from: "2014-01-01T01:00:00Z", to: "2015-01-01T01:00:00Z" }
    assert_response :success
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T13:02:00Z", "user" => "Alice", "type" => "highfive", "otheruser" => "bob"}]
  end

  test "select events by date range" do
    post :create, {"date" => "2014-02-28T13:00:00Z", "user" => "Alice", "type" => "enter" }
    post :create, {"date" => "2014-02-28T14:00:00Z", "user" => "Bob", "type" => "enter" }
    post :create, {"date" => "2014-03-01T13:00:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}
    post :create, {"date" => "2014-03-02T13:02:00Z", "user" => "Alice", "type" => "highfive", "otheruser" => "bob"}
    get :index, { from: "2014-02-28T14:00:00Z", to: "2014-03-02T01:00:00Z" }
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T14:00:00Z", "user" => "Bob", "type" => "enter" },
                                             {"date" => "2014-03-01T13:00:00Z", "user" => "Alice", "type" => "comment", "message" => "hello, this is a sample message"}]
  end

  test "summary by minute" do
    post :create, {"date" => "2010-02-28T13:00:01Z", "user" => "Alice", "type" => "enter" }
    post :create, {"date" => "2014-02-28T13:00:02Z", "user" => "Alice", "type" => "enter" }
    post :create, {"date" => "2014-02-28T13:00:03Z", "user" => "Bob", "type" => "enter" }
    post :create, {"date" => "2014-02-28T13:00:04Z", "user" => "Alice", "type" => "leave" }
    post :create, {"date" => "2014-02-28T13:10:05Z", "user" => "Alice", "type" => "comment", "message" => "Hello" }
    get :summary, { from: "2014-01-01T14:00:00Z", to: "2015-01-01T01:00:00Z", by: 'minute' }
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T13:00:00Z", "enters" => 2, "leaves" => 1, "comments" => 0, "highfives" => 0},
                                             {"date" => "2014-02-28T13:10:00Z", "enters" => 0, "leaves" => 0, "comments" => 1, "highfives" => 0}]
  end

  test "summary by hour" do
    post :create, {"date" => "2010-02-28T13:01:00Z", "user" => "Alice", "type" => "enter" }
    post :create, {"date" => "2014-02-28T13:02:00Z", "user" => "Alice", "type" => "enter" }
    post :create, {"date" => "2014-02-28T13:03:00Z", "user" => "Bob", "type" => "enter" }
    post :create, {"date" => "2014-02-28T13:04:00Z", "user" => "Alice", "type" => "leave" }
    post :create, {"date" => "2014-02-28T17:10:00Z", "user" => "Alice", "type" => "comment", "message" => "Hello" }
    get :summary, { from: "2014-01-01T14:00:00Z", to: "2015-01-01T01:00:00Z", by: 'hour' }
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T13:00:00Z", "enters" => 2, "leaves" => 1, "comments" => 0, "highfives" => 0},
                                             {"date" => "2014-02-28T17:00:00Z", "enters" => 0, "leaves" => 0, "comments" => 1, "highfives" => 0}]
  end

  test "summary by day" do
    post :create, {"date" => "2010-02-28T13:01:00Z", "user" => "Alice", "type" => "enter" }
    post :create, {"date" => "2014-02-28T14:02:00Z", "user" => "Alice", "type" => "enter" }
    post :create, {"date" => "2014-02-28T15:03:00Z", "user" => "Bob", "type" => "enter" }
    post :create, {"date" => "2014-02-28T16:04:00Z", "user" => "Alice", "type" => "leave" }
    post :create, {"date" => "2014-03-02T17:10:00Z", "user" => "Alice", "type" => "comment", "message" => "Hello" }
    get :summary, { from: "2014-01-01T14:00:00Z", to: "2015-01-01T01:00:00Z", by: 'day' }
    assert_equal JSON.parse(response.body), [{"date" => "2014-02-28T00:00:00Z", "enters" => 2, "leaves" => 1, "comments" => 0, "highfives" => 0},
                                             {"date" => "2014-03-02T00:00:00Z", "enters" => 0, "leaves" => 0, "comments" => 1, "highfives" => 0}]
  end

end
