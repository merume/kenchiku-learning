require 'rails_helper'

RSpec.describe Figure, type: :model do
  let(:license_type) { LicenseType.create!(code: 'L1', name: 'LT') }
  let(:exam) { Exam.create!(year: 2020, license_type: license_type) }
  let(:subject) { Subject.create!(code: 'S1', name: 'Sub', license_type: license_type) }
  let(:question) { Question.create!(number: 1, body: 'Q', exam: exam, subject: subject, question_type: :single_statement) }

  it 'belongs to a polymorphic attachable' do
    expect(Figure.reflect_on_association(:attachable)).not_to be_nil
  end

  it 'validates position presence when explicitly nil' do
    figure = Figure.new(position: nil, attachable: question)
    expect(figure).to be_invalid
    expect(figure.errors[:position]).to be_present
  end

  it 'requires an attached image' do
    figure = Figure.new(position: 1, attachable: question)
    expect(figure).to be_invalid
    expect(figure.errors[:image]).to include('を添付してください')
  end

  it 'is valid when image.attached? returns true' do
    figure = Figure.new(position: 1, attachable: question)
    allow(figure).to receive_message_chain(:image, :attached?).and_return(true)
    expect(figure).to be_valid
  end
end
