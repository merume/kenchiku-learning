require 'rails_helper'

RSpec.describe QuestionTag, type: :model do
  let(:license_type) { LicenseType.create!(code: 'L1', name: 'LT') }
  let(:exam) { Exam.create!(year: 2020, license_type: license_type) }
  let(:subject) { Subject.create!(code: 'S1', name: 'Sub', license_type: license_type) }
  let(:question) { Question.create!(number: 1, body: 'Q', exam: exam, subject: subject, question_type: :single_statement) }
  let(:tag) { Tag.create!(name: 'foo') }

  it 'belongs to question and tag' do
    expect(QuestionTag.reflect_on_association(:question)).not_to be_nil
    expect(QuestionTag.reflect_on_association(:tag)).not_to be_nil
  end

  it 'validates uniqueness of tag_id scoped to question_id' do
    QuestionTag.create!(question: question, tag: tag)
    duplicate = QuestionTag.new(question: question, tag: tag)
    expect(duplicate).to be_invalid
    expect(duplicate.errors[:tag_id]).to be_present
  end
end
