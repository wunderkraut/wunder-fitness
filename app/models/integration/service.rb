class Integration::Service
  attr_reader :oauth_scopes
  attr_reader :oauth_authorize_url
  attr_reader :oauth_token_url
  attr_reader :oauth_headers

  attr_reader :client_id
  attr_reader :client_secret
  attr_reader :site_url

  attr_accessor :oauth2_client

  def initialize
    @client_id = Figaro.env.send(name + "_client_id!")
    @client_secret = Figaro.env.send(name + "_client_secret!")
    @site_url = Figaro.env.send(name + "_site_url!")
    @oauth_headers = {}

    # Call configuration method.
    configuration
  end

  def configuration

  end

  def oauth2_client
    return @oauth2_client if @oauth2_client

    options = {
      :site => self.site_url,
    }
    options[:authorize_url] = self.oauth_authorize_url if self.oauth_authorize_url
    options[:token_url] = self.oauth_token_url if self.oauth_token_url
    oauth2_client = OAuth2::Client.new(self.client_id, self.client_secret, options)
  end

  def name
    self.class.name.demodulize.underscore
  end

  #  What happens when token appears?
  def access_token=(access_token)
    @access_token = access_token
  end

  def access_token
    @access_token
  end

  def update_activities(integration_user)
    raise NotImplementedError "All service subclasses must implement the update_activities method."
  end

  # Return the unique user ID from user data.
  def user_id(data)
    raise NotImplementedError "All service subclasses must implement the user_id method."
  end
end