class RingleyReminder
  def initialize (rules)
    @rules = rules
  end

  def rules
    @rules
  end

  def date= date
    @check_date = date
  end

  def on (date, estates)
    @check_date = date

    reminders = []

    estates.each { |estate|
      charges = Charge.where('estate_code = ?', estate)
      charges.each { |charge|
        upcoming_due_dates = upcoming(charge)

        if upcoming_due_dates.any?
          reminders << {:estate => estate, :due_dates => upcoming_due_dates} 
        end
      }

    }

    reminders 
  end

  private

  # Converts a date in format '%m-%d' in a
  # real Date object depending on the year
  # of the date we are checking
  def get_full_due_date(due_date, checking_date_year)
    due_date = Date.strptime("#{checking_date_year}-#{due_date}", " %Y-%m-%d")
  end

  # Get upcoming due dates comparing them to a range
  def upcoming (charge)
    due_dates = []

    due_date = get_full_due_date(charge.due_date, @check_date.year)

    @rules.each { |rule|
      if rule[:period] == charge.period
        if ((due_date - rule[:time])..due_date).cover?(@check_date)
          due_dates << due_date
        end
      end
    }

    due_dates
  end
end
