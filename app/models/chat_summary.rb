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
    summary_list = []
    event_hash.each do |date, date_events|
      summary_list << {'date' => date.iso8601, 'enters' => count_events(date_events, 'enter'), 'leaves' => count_events(date_events, 'leave'),
                       'comments' => count_events(date_events, 'comment'), 'highfives' => count_events(date_events, 'highfive') }
    end
    summary_list
  end

  private

    def count_events(events, type)
      events.count { |x| x.type == type }
    end

    def date_at_granularity(time, granularity)
      return time.beginning_of_minute if granularity == 'minute'
      return time.beginning_of_hour if granularity == 'hour'
      return time.beginning_of_day if granularity == 'day'
      raise "Unknown granularity #{granularity}"
    end

end