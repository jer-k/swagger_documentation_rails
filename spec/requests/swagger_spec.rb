require 'rails_helper'

RSpec.describe 'the API', type: :apivore, order: :defined do
  subject { Apivore::SwaggerChecker.instance_for('/internal/docs/swagger.json') }

  it 'validates the swagger document to be Swagger 2.0 compliant' do
    expect(subject).to be_a(Apivore::SwaggerChecker)
    expect(subject.swagger).to be_a(Hash)
    #Any more validation of your Swagger documentation can be done here
  end
end