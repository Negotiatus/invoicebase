SimpleCov.start 'rails' do
  add_filter "/test/"

  add_group "Models", "app/models"
  add_group "Models", "app/models/(?!(validators|concerns))"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
  add_group "Services", "app/services"
  add_group "Validators", "app/models/validators"
  add_group "Concerns", "app/models/concerns"
end
