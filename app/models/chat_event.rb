class ChatEvent

  attr_reader :date, :type

  def initialize(event_params)
    @date = event_params['date'].to_time.utc
    @user = event_params['user']
    @type = event_params['type']
    @otheruser = event_params['otheruser'] if event_params['otheruser'].present?
    @message = event_params['message'] if event_params['message'].present?
  end

end