require 'rails_helper'

RSpec.describe LicenseType, type: :model do
  it 'has many subjects and exams' do
    expect(LicenseType.reflect_on_association(:subjects)).not_to be_nil
    expect(LicenseType.reflect_on_association(:exams)).not_to be_nil
  end

  it 'validates presence and uniqueness of code and presence of name' do
    lt = LicenseType.new
    expect(lt).to be_invalid
    expect(lt.errors[:code]).to be_present
    expect(lt.errors[:name]).to be_present

    LicenseType.create!(code: 'L1', name: 'LT')
    dup = LicenseType.new(code: 'L1', name: 'LT2')
    expect(dup).to be_invalid
    expect(dup.errors[:code]).to be_present
  end
end
