class ReflectionAnalyzer
  def initialize(entry)
    @entry = entry
  end

  def process_keywords
    descriptions = [
      @entry.physical_description,
      @entry.intellectual_description,
      @entry.emotional_description,
      @entry.spiritual_description
    ]

    descriptions.compact.each do |text|
      words = text.downcase.scan(/\b[a-z]{3,}\b/)
      words.each do |word|
        next if ReflectionTip.exists?(word: word)

        cleaned = word.strip
        next if ReflectionAnalyzer::STOP_WORDS.include?(cleaned)

        UnmatchedKeyword.find_or_initialize_by(word: cleaned).tap do |kw|
          kw.category ||= detect_category(text)
          kw.count ||= 0
          kw.count += 1
          kw.example ||= text
          kw.save!
        end
      end
    end
  end

  private
  STOP_WORDS = %w[
  i me my myself we our ours ourselves you your yours yourself yourselves he him his
  himself she her hers herself it its itself they them their theirs themselves what
  which who whom this that these those am is are was were be been being have has had
  having do does did doing a an the and but if or because as until while of at by for
  with about against between into through during before after above below to from up
  down in out on off over under again further then once here there when where why how
  all any both each few more most other some such no nor not only own same so than too
  very can will just don don’t should now day
].freeze

  def detect_category(text)
    if text == @entry.physical_description
      "physical"
    elsif text == @entry.intellectual_description
      "intellectual"
    elsif text == @entry.emotional_description
      "emotional"
    else
      "spiritual"
    end
  end
end