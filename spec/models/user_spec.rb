require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    
    it { should have_secure_password }
    
    # before bcrypt: it { should validate_presence_of(:password_digest) }
  end

  it "can create a user" do
    # before bcrypt:
      # harry = User.create(email: "harry@hogwarts.com", password_digest: "ImmaWizard!")
      # expect(harry).to have_attribute(:email)
      # expect(harry).to have_attribute(:password_digest)
    
    harry = User.create(email: "harry@hogwarts.com", password: "ImmaWizard!", password_confirmation: "ImmaWizard!")
    expect(harry).to have_attribute(:email) 
    expect(harry).to_not have_attribute(:password)
    expect(harry.password_digest).to_not eq("ImmaWizard!")
  end
end