require "test_helper"

class DrillerSessionsControllerTest < ActionController::TestCase
  test "should not redirect on unsuccessful login" do
    User.create!(email: "joe.blow@erdosmiller.com", password: "iamjoe",
                 password_confirmation: "iamjoe", name: "Joe Blow")
    post :create, {email:"joe@erdosmiller.com", password:"iamjoe"}
    assert_response 200
  end

  test "should not redirect on invalid job number" do
    User.create!(email: "joe.blow@erdosmiller.com", password: "iamjoe",
                 password_confirmation: "iamjoe", name: "Joe Blow")
    post :create, {email:"joe@erdosmiller.com", password:"iamjoe",
                   job_number:"EX-123456"}
    assert_response 200
  end

  test "should not redirect on invalid run number" do
    User.create!(email: "joe.blow@erdosmiller.com", password: "iamjoe",
                 password_confirmation: "iamjoe", name: "Joe Blow")
    Job.create!(name: "EX-123456")
    post :create, {email: "joe@erdosmiller.com", password: "iamjoe",
                   job_number: "EX-123456", run_number: 1}
    assert_response 200
  end

  test "should log in successfully" do
    User.create!(email: "joe.blow@erdosmiller.com", password: "iamjoe",
                 password_confirmation: "iamjoe", name: "Joe Blow")
    job = Job.create! name: "EX-123456"
    Run.create! number: 1, job: job
    post :create, {email: "joe.blow@erdosmiller.com", password: "iamjoe",
                   job_number: "EX-123456", run_number: 1}
    assert_redirected_to root_path
  end

  test "email and job should not be case sensitive" do
    User.create!(email: "joe.blow@erdosmiller.com", password: "iamjoe",
                 password_confirmation: "iamjoe", name: "Joe Blow")
    job = Job.create!(name: "EX-123456")
    Run.create! number: 111, job: job
    post :create, {email: "JOE.BLOW@ERDOSMILLER.COM", password: "iamjoe",
                   job_number: "Ex-123456", run_number: 111}
    assert_redirected_to root_path
  end

end
