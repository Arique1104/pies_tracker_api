class UnmatchedKeywordSerializer < ActiveModel::Serializer
  attributes :id, :word, :category, :count, :example, :created_at, :updated_at
end
