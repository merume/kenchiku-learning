require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:license_type) { LicenseType.create!(code: 'L1', name: 'LT') }
  let(:exam) { Exam.create!(year: 2020, license_type: license_type) }
  let(:subject) { Subject.create!(code: 'S1', name: 'Sub', license_type: license_type) }

  describe 'associations and enums' do
    it 'belongs to exam and subject' do
      expect(Question.reflect_on_association(:exam)).not_to be_nil
      expect(Question.reflect_on_association(:subject)).not_to be_nil
    end

    it 'defines question_type enum' do
      expect(Question.question_types).to include('single_statement')
    end
  end

  describe 'validations and callbacks' do
    it 'validates presence of number and body' do
      q = Question.new(exam: exam, subject: subject)
      expect(q).to be_invalid
      expect(q.errors[:number]).to be_present
      expect(q.errors[:body]).to be_present
    end

    it 'sets flashcard_eligible from question_type before validation' do
      q = Question.new(number: 1, body: 'text', exam: exam, subject: subject, question_type: :single_statement)
      q.valid?
      expect(q.flashcard_eligible).to be true

      q2 = Question.new(number: 2, body: 'text', exam: exam, subject: subject, question_type: :calculation)
      q2.valid?
      expect(q2.flashcard_eligible).to be false
    end
  end

  describe '#correct_choice' do
    it 'returns the choice marked as correct' do
      q = Question.create!(number: 1, body: 'Q', exam: exam, subject: subject, question_type: :single_statement)
      q.choices.create!(number: 1, body: 'A', is_correct: false, is_true_statement: false)
      q.choices.create!(number: 2, body: 'B', is_correct: true, is_true_statement: true)

      expect(q.correct_choice.number).to eq 2
    end
  end

  it 'returns nil when no correct choice is present' do
    q = Question.create!(number: 3, body: 'No correct', exam: exam, subject: subject, question_type: :single_statement)
    q.choices.create!(number: 1, body: 'A', is_true_statement: false)
    expect(q.correct_choice).to be_nil
  end

  it 'orders choices by number through association' do
    q = Question.create!(number: 4, body: 'Order test', exam: exam, subject: subject, question_type: :single_statement)
    q.choices.create!(number: 3, body: 'C', is_true_statement: false)
    q.choices.create!(number: 1, body: 'A', is_true_statement: false)
    q.choices.create!(number: 2, body: 'B', is_true_statement: false)

    expect(q.choices.map(&:number)).to eq [1, 2, 3]
  end
end
