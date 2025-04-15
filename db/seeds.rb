# db/seeds.rb

puts "🌱 Seeding data..."

TeamAssignment.destroy_all
PiesEntry.destroy_all
ReflectionTip.destroy_all
User.destroy_all
UnmatchedKeyword.destroy_all
# Helper to generate random scores and descriptions
def random_score
  rand(1..10)
end

def random_description
  ["Feeling reflective", "Need more rest", "High energy day", "A bit off today", "Focused and calm"].sample
end

def random_date(days_ago)
  days_ago.days.ago.to_date
end

# Create Owners
2.times do |i|
  User.create!(
    name: "Owner #{i + 1}",
    email: "owner#{i + 1}@example.com",
    password: "password",
    role: :owner
  )
end

# Create Leaders
leaders = 5.times.map do |i|
  User.create!(
    name: "Leader #{i + 1}",
    email: "leader#{i + 1}@example.com",
    password: "password",
    role: :leader
  )
end

# Each leader gets 5 PIES entries
leaders.each do |leader|
  5.times do |i|
    PiesEntry.create!(
      user: leader,
      checked_in_on: random_date(i),
      physical: random_score,
      physical_description: random_description,
      intellectual: random_score,
      intellectual_description: random_description,
      emotional: random_score,
      emotional_description: random_description,
      spiritual: random_score,
      spiritual_description: random_description
    )
  end
end

# Create Individuals
individuals = 15.times.map do |i|
  User.create!(
    name: "Individual #{i + 1}",
    email: "individual#{i + 1}@example.com",
    password: "password",
    role: :individual
  )
end

# Each individual gets 5 PIES entries
individuals.each do |ind|
  5.times do |i|
    PiesEntry.create!(
      user: ind,
      checked_in_on: random_date(i),
      physical: random_score,
      physical_description: random_description,
      intellectual: random_score,
      intellectual_description: random_description,
      emotional: random_score,
      emotional_description: random_description,
      spiritual: random_score,
      spiritual_description: random_description
    )
  end
end

# 100 random Reflection Tips
words = %w[rest hydrate read focus journal breathe listen create walk stretch meditate reflect connect balance study express empathize forgive explore pray]
categories = %w[physical intellectual emotional spiritual]

100.times do
  word = words.sample
  category = categories.sample
  ReflectionTip.create!(
    word: word,
    category: category,
    tip: "#{word.capitalize} is a great way to enhance your #{category} well-being. Try integrating it into your routine with intention.",
    created_at: Time.now,
    updated_at: Time.now
  )
end

#create 10 Unmatched Keywords
UnmatchedKeyword.create!(
  word: "groggy",
  category: "physical",
  count: 7,
  example: "Eat onto official still investment put yourself something friend.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "scatterbrained",
  category: "intellectual",
  count: 8,
  example: "Price blue raise throughout prepare detail care it born six.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "wistful",
  category: "emotional",
  count: 10,
  example: "Environmental four crime list experience drug subject daughter soon stage lose.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "spaced",
  category: "spiritual",
  count: 1,
  example: "Collection write four apply pay which tend when lawyer.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "overwhelmed",
  category: "emotional",
  count: 1,
  example: "Teach back military people only day then quickly.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "energized",
  category: "physical",
  count: 9,
  example: "Relationship type stay from skin shoulder exist.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "zoned",
  category: "spiritual",
  count: 3,
  example: "Economic surface me something born same myself recently.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "numb",
  category: "emotional",
  count: 8,
  example: "Land evening feel up present whole ask deal from stock modern.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "restless",
  category: "physical",
  count: 9,
  example: "Beyond in quite as election body baby fund discussion value chair whatever human.",
  created_at: Time.now,
  updated_at: Time.now
)

UnmatchedKeyword.create!(
  word: "uncertain",
  category: "intellectual",
  count: 1,
  example: "Here for whose daughter site us peace property.",
  created_at: Time.now,
  updated_at: Time.now
)
puts "✅ Done seeding!"
