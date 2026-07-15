require 'rails_helper'

RSpec.describe Choice, type: :model do
  let(:license_type) { LicenseType.create!(code: 'L1', name: 'LT') }
  let(:exam) { Exam.create!(year: 2020, license_type: license_type) }
  let(:subject) { Subject.create!(code: 'S1', name: 'Sub', license_type: license_type) }
  let(:question) { Question.create!(number: 1, body: 'Q', exam: exam, subject: subject, question_type: :single_statement) }

  it 'belongs to question' do
    expect(Choice.reflect_on_association(:question)).not_to be_nil
  end

  it 'validates number inclusion and uniqueness within question' do
    c = question.choices.build(number: 6, body: 'too high')
    expect(c).to be_invalid
    expect(c.errors[:number]).to be_present

    question.choices.create!(number: 1, body: 'A', is_true_statement: false)
    dup = question.choices.build(number: 1, body: 'B', is_true_statement: false)
    expect(dup).to be_invalid
    expect(dup.errors[:number]).to be_present
  end

  it 'requires is_true_statement when question is flashcard eligible' do
    # question is single_statement by default in this setup -> flashcard eligible
    c = question.choices.build(number: 2, body: 'B')
    expect(c).to be_invalid
    expect(c.errors[:is_true_statement]).to be_present
  end

  it 'accepts boundary numbers 1 and 5' do
    c1 = question.choices.build(number: 1, body: 'A', is_true_statement: false)
    c5 = question.choices.build(number: 5, body: 'E', is_true_statement: false)
    expect(c1).to be_valid
    expect(c5).to be_valid
  end

  it 'allows nil is_true_statement when question is not flashcard eligible' do
    q = Question.create!(number: 9, body: 'calc', exam: exam, subject: subject, question_type: :calculation)
    c = q.choices.build(number: 1, body: 'Any')
    expect(c).to be_valid
  end
end
