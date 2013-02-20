class ReminderController < ApplicationController
  def index
    rules =
    [
      { :period => 'quarterly',    :time => 1.month },
      { :period => 'twice_a_year', :time => 2.month }
    ]
    
    reminder = RingleyReminder.new(rules)

    @check_date = Date.strptime('01/01/2013', '%d/%m/%Y')
    estates = ['0066S', '0123S', '0250S']
    @reminders = reminder.on(@check_date, estates)
  end
end
