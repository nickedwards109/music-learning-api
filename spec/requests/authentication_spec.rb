require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  it "responds with a 404 Not Found and no JSON web token when a client POSTS with invalid credentials" do
    user = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    post '/api/v1/sessions?session[email]=asdf&session[password]=1234'
    expect(response).to have_http_status(404)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response).not_to have_key("token")

    post '/api/v1/sessions?session[email]=admin%40example.com&session[password]=1234'
    expect(response).to have_http_status(404)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response).not_to have_key("token")
  end

  it "responds with a 200 OK and a JSON web token when a client POSTS with valid credentials" do
    user = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    post '/api/v1/sessions?session[email]=admin%40example.com&session[password]=85kseOlqqp%21v1%40a7'
    expect(response).to have_http_status(200)

    # Get the JSON web token out of the response body
    parsed_response = JSON.parse(response.body)
    expect(parsed_response).to have_key("token")
    encoded_token = parsed_response["token"]

    # The JSON web token should have 3 parts (header, payload, signature), delimited by periods
    expect(encoded_token.split(".").count).to eq(3)
    header = encoded_token.split(".")[0]
    payload = encoded_token.split(".")[1]
    signature = encoded_token.split(".")[2]

    # The header should specify to use the SHA256 algorithm for hashing
    decoded_header = Base64.decode64(header)
    parsed_decoded_header = JSON.parse(decoded_header)
    expect(parsed_decoded_header).to have_key("alg")
    expect(parsed_decoded_header["alg"]).to eq("HS256")

    # The payload should contain a user id and an expiration date
    decoded_payload = Base64.decode64(payload)
    parsed_decoded_payload = JSON.parse(decoded_payload)
    expect(parsed_decoded_payload).to have_key("id")
    expect(parsed_decoded_payload).to have_key("exp")

    # The signature should be a Base64URL encoding of the hashed header and payload
    key = Rails.application.credentials.secret_key_base
    header_and_payload = header + "." + payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    expected_signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    expect(signature).to eq(expected_signature)
  end
end
