class DisplaySequence

  attr_accessor :value,
                :result,
                :loop_count

  def initialize(loop_count=6)
    self.value = "1"
    self.result = nil
    self.loop_count = loop_count
    Rails.logger.info value if Rails.env.development?
  end

  def show_sequence
    (0...loop_count).each do |i|
      self.result = value.chars.inject([]) do |arr, numb|
        add_or_update_pairs_array(arr, numb)
        arr
      end
      reverse_pairs
    end
    result
  end

  def add_or_update_pairs_array(arr, numb)
    if arr.present? && arr.last.has_key?(numb)
      arr.last[numb] += 1
    else
      arr << {numb => 1}
    end
  end

  def reverse_pairs
    self.value.clear
    result.map do |hash|
      hash.each_pair{ |k,v| self.value << "#{v}#{k}" }
    end
    Rails.logger.info "  [DisplaySequence] show sequence: #{value}" if Rails.env.development?
  end
end
