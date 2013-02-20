require 'test/unit'
require 'ringley_reminder'

class RingleyReminderTest < Test::Unit::TestCase
  def setup
    rules =
    [
      { :period => 'quarterly',    :time => 1.month },
      { :period => 'twice_a_year', :time => 2.month }
    ]
    @check_date = Date.strptime('01/01/2013', '%d/%m/%Y')
    @estates = ['0066S']

    @reminder = RingleyReminder.new(rules)
  end

  def test_rules_is_an_array
    assert @reminder.rules.is_a?(Array)
  end

  def test_get_full_due_date_returns_a_date
    date = @reminder.send(:get_full_due_date, Charge.first.due_date, @check_date)

    assert date.is_a?(Date)
  end

  def test_upcoming_returns_upcoming_due_dates
    @reminder.date = @check_date

    charge = Charge.where('estate_code = ? AND due_date = ?',
                          @estates[0], '02-01').first

    due_dates = @reminder.send(:upcoming, charge)

    puts "Total of due dates for #{charge.estate_code} at #{@check_date}:"
    puts "#{due_dates.length} found !"

    assert_operator due_dates.length, '>', 0
  end

  def test_on_returns_reminders

    reminders = @reminder.on(@check_date, @estates)

    puts "Total of reminders for #{@estates[0]} at #{@check_date}:"
    puts "#{reminders.length} found !"

    assert_operator reminders.length, '>', 0
  end
end
