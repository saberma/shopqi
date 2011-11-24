# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
  watch(%r{app/.+\.(erb|haml)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
end

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' }, :wait => 45 do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch(%r{^app/controllers/.+\.rb})
  watch(%r{^app/models/.+\.rb})
  watch(%r{^app/liquids/.+\.rb})
  watch(%r{^app/observers/.+\.rb})
end

guard 'rspec', :cli => "--fail-fast --drb --tag f" do #只跑tag为f的测试，这样就不会造成改一个单元测试的地方，要跑整个file的测试
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }

  # Rails example
  watch('spec/spec_helper.rb')                       { "spec" }
  watch('config/routes.rb')
  watch('app/controllers/application_controller.rb') { "spec/controllers" }
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
end

