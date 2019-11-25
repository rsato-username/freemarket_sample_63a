Recaptcha.configure do |config|   
  config.Recaptcha = ENV['RECAPTCHA_SITE_KEY']
  config.Recaptcha = ENV['RECAPTCHA_SECRET_KEY']
# Uncomment the following line if you are using a proxy server:   
# config.proxy = 'http://myproxy.com.au:8080' 
end