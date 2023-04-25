require "rails_helper"

RSpec.describe "/api/v1/users" do
  describe "#create" do
    describe "happy path tests" do
      let(:user_params) { { email: "DumbledoreSchoolEmail@hogwarts.com", password: "ImmaWizard!", password_confirmation: "ImmaWizard!" } }

      it "can create a new user" do
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        # expect(response).to be_successful
        expect(response).to have_http_status(201)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:id]).to be_a(String)
        expect(parsed_data[:data][:type]).to eq("users")
        expect(parsed_data[:data][:type]).to eq("users")
        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:email, :api_key])
        expect(parsed_data[:data][:attributes][:email]).to eq("dumbledoreschoolemail@hogwarts.com")
        expect(parsed_data[:data][:attributes][:api_key]).to be_a(String)
      end
    end

    describe "sad path tests" do
      let(:expected_hash) { 
        {
          "errors":
          [{
              "status": '404',
              "title": 'Invalid Request',
              "detail": ["Credentials are incorrect."]
            }]
        }
      }

      it "returns error message when password & password_confirmation don't match" do
        user_params = { email: "HarrySchoolEmail@hogwarts.com", password: "ImmaWizard!", password_confirmation: "WizardIam!" } 
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response).to eq(expected_hash)
      end

      it "returns error message when input is nil/empty" do
        user_params = { email: nil, password: "ImmaWizard!", password_confirmation: "WizardIam!" } 
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response).to eq(expected_hash)
      end

      it "returns error message when email is already taken/not unique" do
        harry = User.create({ email: "harryschoolemail@hogwarts.com", password: "ImmaWizard!", api_key: SecureRandom.hex })
        user_params = { email: "HarrySchoolEmail@hogwarts.com", password: "NotHarry", password_confirmation: "NotHarry" } 
        
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response).to eq(expected_hash)
      end
    end
  end

  describe "#login" do
    describe "happy path tests" do
      it "can log in a user with valid credentials" do
        ron = User.create({ email: "ronschoolemail@hogwarts.com", password: "ImmaWizardtoo!", api_key: SecureRandom.hex })
        user_params = { email: "RonSchoolEmail@hogwarts.com", password: "ImmaWizardtoo!" } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(200)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data][:id]).to be_a(String)
        expect(parsed_data[:data][:type]).to eq("users")
        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:email, :api_key])
      end
    end

    describe "sad path tests" do
      let(:expected_hash) { 
        {
          "errors":
          [{
              "status": '404',
              "title": 'Invalid Request',
              "detail": ["Credentials are incorrect to login."]
            }]
        }
      }
      
      it "returns error message when password is invalid" do
        ron = User.create({ email: "ronschoolemail@hogwarts.com", password: "ImmaWizardtoo!", api_key: SecureRandom.hex })
        user_params = { email: "RonSchoolEmail@hogwarts.com", password: "ImmaWrongPassword" } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to eq(expected_hash)
      end

      it "returns error message when email is invalid" do
        ron = User.create({ email: "ronschoolemail@hogwarts.com", password: "ImmaWizardtoo!", api_key: SecureRandom.hex })
        user_params = { email: "HermioneSchoolEmail@hogwarts.com", password: "ImmaWizardtoo!" } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to eq(expected_hash)
      end

      it "returns error message when input is nil/missing" do
        expected_hash = {
          "errors":
          [{
              "status": '404',
              "title": 'Invalid Request',
              "detail": ["Credentials cannot be missing."]
            }]
        }

        user_params = { email: nil, password: "ImmaWizardtoo!" } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to eq(expected_hash)
      end
    end
  end
end