require "test_helper"

class EventNotifierTest < ActionMailer::TestCase
  tests EventNotifier

  test "crossover email" do
    event = create( :event, tags: {"crossover" => true} )
    user = create( :user, roles: ["Email Crossover Events"] )

    assert_equal( {"crossover" => true}, event.tags )
    EventNotifier.crossover_email( event )
    sent = ActionMailer::Base.deliveries.first

    assert_equal [user.email], sent.to
    assert_equal "Crossover Event Occurance", sent.subject
    assert sent.body.include?( "events/#{event.id}" )
  end

  test "it should send to every person with Email Crossover Events role" do
    User.all.each {|u| u.update_attributes! roles: u.roles.select{|r| r != "Email Crossover Events"}}
    event = create( :event, tags: {"crossover" => true} )
    create( :user, roles: ["Email Crossover Events"] )
    create( :user, email: "another@email.com", roles: ["Email Crossover Events"] )

    EventNotifier.crossover_email( event )
    queue = ActionMailer::Base.deliveries

    assert_equal 2, queue.length
  end
end
