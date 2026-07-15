require 'rails_helper'

RSpec.describe Tag, type: :model do
  it 'has many question_tags and questions through them' do
    expect(Tag.reflect_on_association(:question_tags)).not_to be_nil
    expect(Tag.reflect_on_association(:questions)).not_to be_nil
  end

  it 'validates presence and uniqueness of name' do
    t = Tag.new
    expect(t).to be_invalid
    expect(t.errors[:name]).to be_present

    Tag.create!(name: 'foo')
    dup = Tag.new(name: 'foo')
    expect(dup).to be_invalid
    expect(dup.errors[:name]).to be_present
  end
end
