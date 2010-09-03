# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_testguru_session',
  :secret      => '28a4d232fb3d53a39b49433550188d73d0346e16fc892240d0a7373bea7a67af71ffdf511c6d99be15e22bb7bf0ea30f907baedad2f5b2a2caa67b19b508ca70'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
