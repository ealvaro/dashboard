require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  test "should not be case sensitive" do
    User.create!( email: "joe.blow@erdosmiller.com", password: "iamjoe", password_confirmation: "iamjoe", name: "Joe Blow")
    post :create, {email:"JOE.BLOW@ERDOSMILLER.COM", password:"iamjoe"}
    assert_redirected_to root_path
  end

  test "should strip whitespace" do
    User.create!( email: " joe.blow@erdosmiller.com ", password: "iamjoe", password_confirmation: "iamjoe", name: "Joe Blow")
    post :create, {email:"joe.blow@erdosmiller.com", password:"iamjoe"}
    assert_redirected_to root_path
  end

  test "should log in successfully" do
    User.create!( email: "joe.blow@erdosmiller.com", password: "iamjoe", password_confirmation: "iamjoe", name: "Joe Blow")
    post :create, {email:"joe.blow@erdosmiller.com", password:"iamjoe"}
    assert_redirected_to root_path
  end

  test "should not redirect on unsuccessful login" do
    User.create!( email: "joe.blow@erdosmiller.com", password: "iamjoe", password_confirmation: "iamjoe", name: "Joe Blow")
    post :create, {email:"joe@erdosmiller.com", password:"iamjoe"}
    assert_response 200
  end
end
