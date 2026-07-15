require 'rails_helper'

RSpec.describe Exam, type: :model do
  let(:license_type) { LicenseType.create!(code: 'L1', name: 'LT') }

  it 'belongs to license_type and has many questions' do
    expect(Exam.reflect_on_association(:license_type)).not_to be_nil
    expect(Exam.reflect_on_association(:questions)).not_to be_nil
  end

  it 'validates presence and uniqueness of year scoped to license_type' do
    e = Exam.new(license_type: license_type)
    expect(e).to be_invalid
    expect(e.errors[:year]).to be_present

    Exam.create!(year: 2020, license_type: license_type)
    dup = Exam.new(year: 2020, license_type: license_type)
    expect(dup).to be_invalid
    expect(dup.errors[:year]).to be_present
  end

  it 'allows same year for different license_types' do
    Exam.create!(year: 2021, license_type: license_type)
    other = LicenseType.create!(code: 'L2', name: 'LT2')
    e2 = Exam.new(year: 2021, license_type: other)
    expect(e2).to be_valid
  end
end
