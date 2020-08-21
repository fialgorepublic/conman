Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '688543001833-oaerr3um6e4vto01affhp819oqvvfgll.apps.googleusercontent.com', 'lBDXL_o7ARrqmfAQSkspkfso',
  {
    name: 'google',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 512,
    info_fields: 'email,name,first_name,last_name,gender, birthday',
    scope: 'https://mail.google.com/,https://www.googleapis.com/auth/userinfo.email',
    client_options: {
      ssl: {
        ca_file: Rails.root.join('lib', 'assets', 'cacert.pem').to_s
      }
    }
  }
end
