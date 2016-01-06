namespace :swagger do
  dest_dir = 'public/internal/swagger-ui'

  desc 'Copies swagger-ui dist files from bower to public/'
  task create: :clean do
    cp_r 'bower_components/swagger-ui/dist', dest_dir
    ln_sf Rails.root.join('public/internal/docs/swagger-ui-index.html'), "#{dest_dir}/index.html"
  end

  desc 'Removes the swagger-ui files in public'
  task :clean do
    rm_rf dest_dir
  end
end
