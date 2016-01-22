class ChatSummary

  attr_reader :events
  def initialize(events)
    @events = events
  end

  def summarize_by(granularity)
    event_hash = Hash.new {|h,k| h[k] = []}
    events.each do |event|
      event_hash[date_at_granularity(event.date, granularity)] << event
    end
    event_hash.map { |date, date_events| summary_json(date, date_events) }
  end

  private

    def date_at_granularity(time, granularity)
      return time.beginning_of_minute if granularity == 'minute'
      return time.beginning_of_hour if granularity == 'hour'
      return time.beginning_of_day if granularity == 'day'
      raise "Unknown granularity #{granularity}"
    end

    def summary_json(date, events)
      {
        'date' => date.iso8601,
        'enters' => count_events(events, 'enter'),
        'leaves' => count_events(events, 'leave'),
        'comments' => count_events(events, 'comment'),
        'highfives' => count_events(events, 'highfive')
      }
    end

    def count_events(events, type)
      events.count { |x| x.type == type }
    end

end