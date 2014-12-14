desc "Rename an App from old_name to new_name"
task :rename_app, [:from_name, :to_name] do |t, args|
  puts "#{args.name}"
  
  camelize_from_name = args.from_name.camelize
  underscore_from_name = args.from_name.underscore
  
  camelize_to_name = args.to_name.camelize
  underscore_to_name = args.to_name.underscore
  
  replace camelize_from_name, camelize_to_name, 'app/views/layouts/application.html.erb'
  replace camelize_from_name, camelize_to_name, 'config/application.rb'
  replace underscore_from_name, underscore_to_name, 'config/initializers/session_store.rb'
end

def replace from_string, to_string, file
  puts "Modify: #{file}"
  puts "sed -i.bak s/#{from_string}/#{to_string}/g #{file}"
  `sed -i.bak "s/#{from_string}/#{to_string}/g" "#{file}"`  
  `rm "#{file}.bak"`
end