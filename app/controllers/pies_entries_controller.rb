class PiesEntriesController < ApplicationController
  def create
    entry = @current_user.pies_entries.new(pies_entry_params)

    if entry.save
      log_unmatched_words(entry)
      render json: entry, status: :created
    else
      render json: { errors: entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    entries = @current_user.pies_entries.order(checked_in_on: :desc)
    render json: entries
  end

  private

  def log_unmatched_words(entry)
  require "set"

  tips = pies_tip_map # You'll need to move your tip map into a service or constant

  categories = %i[physical intellectual emotional spiritual]
  categories.each do |category|
    desc = entry.send("#{category}_description").to_s.downcase
    words = Set.new(desc.scan(/\b[a-z']+\b/)) # unique, simple words

    matched_words = tips[category.to_s].keys.map(&:downcase)

    unmatched = words.reject { |w| matched_words.include?(w) }

    unmatched.each do |word|
      cleaned = word.downcase.strip
    return if STOP_WORDS.include?(cleaned)
      record = UnmatchedKeyword.find_or_initialize_by(word: cleaned, category: category)
      record.count ||= 0
      record.count += 1
      record.example = desc
      record.save
    end
  end
end

def pies_tip_map
  # ideally load this from a service or constant shared with frontend
  JSON.parse(File.read(Rails.root.join("config", "pies_tip_map.json")))
end

  def pies_entry_params
    params.require(:pies_entry).permit(
      :checked_in_on,
      :physical, :physical_description,
      :intellectual, :intellectual_description,
      :emotional, :emotional_description,
      :spiritual, :spiritual_description
    )
  end
end
