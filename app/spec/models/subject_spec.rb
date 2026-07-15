require 'rails_helper'

RSpec.describe Subject, type: :model do
  let(:license_type) { LicenseType.create!(code: 'L1', name: 'LT') }

  it 'belongs to license_type and has many questions' do
    expect(Subject.reflect_on_association(:license_type)).not_to be_nil
    expect(Subject.reflect_on_association(:questions)).not_to be_nil
  end

  it 'validates presence and uniqueness of code scoped to license_type, and presence of name' do
    s = Subject.new(license_type: license_type)
    expect(s).to be_invalid
    expect(s.errors[:code]).to be_present
    expect(s.errors[:name]).to be_present

    Subject.create!(license_type: license_type, code: 'S1', name: 'Sub')
    dup = Subject.new(license_type: license_type, code: 'S1', name: 'Sub2')
    expect(dup).to be_invalid
    expect(dup.errors[:code]).to be_present
  end

  it 'allows same code under different license_types' do
    Subject.create!(license_type: license_type, code: 'S2', name: 'Sub')
    other = LicenseType.create!(code: 'L2', name: 'LT2')
    s2 = Subject.new(license_type: other, code: 'S2', name: 'Other')
    expect(s2).to be_valid
  end
end
