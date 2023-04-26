require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    
    it { should have_secure_password }
  end

  it "can create a user" do
    harry = User.create(email: "harry@hogwarts.com", password: "ImmaWizard!", api_key: "123eXpElLiArMuS456")

    expect(harry.email).to eq("harry@hogwarts.com")

    expect(harry).to have_attribute(:password_digest) 
    expect(harry.password_digest).to_not eq("ImmaWizard!")
    
    expect(harry.api_key).to eq("123eXpElLiArMuS456")
  end
end