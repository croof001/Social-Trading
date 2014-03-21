Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '369232359883635', '9e6c3ec23d980bc03e5ded3f8b4dd712',
  :scope => 'email,user_birthday,read_stream,publish_actions,publish_stream,manage_notifications,manage_friendlists,read_insights,read_friendlists,read_requests,manage_pages,read_page_mailboxes'

  provider :twitter, "rUqzjv3fCnAH5grduFxoUA", "irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co",
           :authorize_params => {
           :force_login => 'true',
           :use_authorize => 'true'
            }
  provider :instagram, ENV['INSTAGRAM_ID'], ENV['INSTAGRAM_SECRET']
  provider  :google_oauth2, "929083618245-qsjtatfob874ejnrenepo5srdckm75k3.apps.googleusercontent.com", "2mCMyE6bOBDrRCYcYk93zgej",
  {
      :name => "google_oauth2",
      :scope => "https://www.googleapis.com/auth/prediction,userinfo.email,userinfo.profile,plus.me",
      :prompt => "consent",
      :image_aspect_ratio => "square",
      :image_size => 50
    }
end