require "rails_helper"

RSpec.describe "/api/v1/users" do
  # For testing real endpoint connection: 
    # before do
    #   WebMock.allow_net_connect!
    # end
    # after do
    #   WebMock.disable_net_connect!
    # end

  describe "#create" do
    describe "happy path tests" do
      let(:user_params) { { email: "DracoSchoolEmail@hogwarts.com", password: "ImmaWizard!", password_confirmation: "ImmaWizard!" } }

      it "can create a new user" do
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(201)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:id]).to be_a(String)
        expect(parsed_data[:data][:type]).to eq("users")
        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:email, :api_key])
        expect(parsed_data[:data][:attributes][:email]).to eq("dracoschoolemail@hogwarts.com")
        expect(parsed_data[:data][:attributes][:api_key]).to be_a(String)
        expect(parsed_data[:data][:attributes][:api_key]).to eq(User.last.api_key)
      end
    end

    describe "sad path tests" do
      let(:expected_hash) { 
        {
          "errors":
          [{
              "status": '404',
              "title": 'Invalid Request',
              "detail": "Credentials are incorrect."
            }]
        }
      }

      it "returns error message when password & password_confirmation don't match" do
        user_params = { email: "DracoSchoolEmail@hogwarts.com", password: "ImmaWizard!", password_confirmation: "ImmaWrongPassword" } 
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response).to eq(expected_hash)
      end

      it "returns error message when email is nil/empty" do
        user_params = { email: nil, password: "ImmaWizard!", password_confirmation: "ImmaWizard!" } 
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/users", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response).to eq(expected_hash)
      end

      it "returns error message when email is already taken/not unique" do
        User.create({ email: "dracoschoolemail@hogwarts.com", password: "ImmaWizard!", api_key: "e8gt1h2i3s4_i9i10t115s6_l7" })
        user_params = { email: "DracoSchoolEmail@hogwarts.com", password: "DracoAgain", password_confirmation: "DracoAgain" } 
        
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
        User.create({ email: "dracoschoolemail@hogwarts.com", password: "ImmaWizard!", api_key: "e8gt1h2i3s4_i9i10t115s6_l7" })
        user_params = { email: "DracoSchoolEmail@hogwarts.com", password: "ImmaWizard!" } 

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
        expect(parsed_data[:data][:attributes][:email]).to eq("dracoschoolemail@hogwarts.com")
        expect(parsed_data[:data][:attributes][:api_key]).to eq(User.last.api_key)
      end
    end

    describe "sad path tests" do
      let(:expected_hash) { 
        {
          "errors":
          [{
              "status": '404',
              "title": 'Invalid Request',
              "detail": "Credentials are incorrect to login."
            }]
        }
      }
      
      it "returns error message when password is invalid" do
        User.create({ email: "dracoschoolemail@hogwarts.com", password: "ImmaWizard!", api_key: "e8gt1h2i3s4_i9i10t115s6_l7" })
        user_params = { email: "DracoSchoolEmail@hogwarts.com", password: "ImmaWrongPassword" } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to eq(expected_hash)
      end

      it "returns error message when email is invalid" do
        User.create({ email: "dracoschoolemail@hogwarts.com", password: "ImmaWizard!", api_key: "e8gt1h2i3s4_i9i10t115s6_l7" })
        user_params = { email: "NotDracoSchoolEmail@hogwarts.com", password: "ImmaWizard!" } 

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
              "detail": "Credentials cannot be missing."
            }]
        }
        user_params = { email: nil, password: "ImmaWizard!" } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/sessions", headers: headers, params: JSON.generate(user_params)

        expect(response).to have_http_status(404)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to eq(expected_hash)
      end
    end
  end
end