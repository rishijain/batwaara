# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['Lunch', 'Dinner', 'Snacks', 'Settlement'].each do |event_name|
  Event.create(name: event_name)
end

event = Event.find_by(name: 'Lunch')

=begin
b = Bill.create(event_id: event.id, member_ids: [1,2,3,4], amount: 400)
t = Transaction.create(user_id: 1, amount_paid: 140, bill_id: b.id)
t = Transaction.create(user_id: 2, amount_paid: 260, bill_id: b.id)

b = Bill.create(event_id: event.id, member_ids: [1,2,3,4], amount: 360)
t = Transaction.create(user_id: 1, amount_paid: 360, bill_id: b.id)

settlement_event = Event.find_by(name: 'Settlement')
b = Bill.create(event_id: settlement_event.id, member_ids: [2,3], paid_to_id: 2, amount: 200)
t = Transaction.create(user_id: 4, amount_paid: 200, bill_id: b.id)
=end

