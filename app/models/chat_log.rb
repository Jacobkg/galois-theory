class ChatLog

  def self.record!(event)
    ChatRepository.save!(event)
  end

  def self.list(from, to)
    events = ChatRepository.search(from, to)
    events.select {|x| x.date >= from && x.date <= to}
  end

end