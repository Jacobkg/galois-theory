class ChatLog

  DATABASE_FILE_NAME = '.chat_database'

  def self.record(params)
    File.open(DATABASE_FILE_NAME, 'a') do |f|
      f.puts params.to_json
    end
  end

  def self.list(from, to)
    event_params_list = File.read(DATABASE_FILE_NAME).lines.map {|x| JSON.parse(x)}
    events = event_params_list.map {|x| ChatEvent.new(x) }
    events.select {|x| x.date >= from && x.date <= to}
  end

  def self.clear_all
    File.delete(DATABASE_FILE_NAME) if File.exist?(DATABASE_FILE_NAME)
  end

end