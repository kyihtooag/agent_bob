# AgentBob

### Who is Bob?
The bot that you can command to search the market data of any cryptocurrency from Coingecko.

### What kind of data?
Bob can search you the market price of any cryptocurrency available on Coingecko in USD value for the last 14 days' data records.

### How to deploy Agent Bob?
Agent Bob uses the Facebook messenger chatbot as a middleware to communicate with the user
 
### Create Facebook App and connect with the facebook page
  * Create new facebook app at [`Facebook App Dashboard`](https://developers.facebook.com/apps/).
  * Add messenger from the product list to your app.
  * Connect your app's messenger with facebook page (if you don't have one,  create it xD) and generate access token.
  
### Add the enviroment variable
  * Create `.env` at the same directory of the code.
  * Add the access token with the name `FACEBOOK_PAGE_ACCESS_TOKEN`.
  * Generat a new string as a `Verify token` for webhook(looks the detail information at `Webhook` section).
  * Add the webhook verify token with the name `FACEBOOK_WEBHOOK_VERIFY_TOKEN`.
  * Run `sourece .env` 
  
### Start your Phoenix server: 

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
  
### Setup Webhook
Bob uses webhook to interacting with facebook chatbot. We have to add our webhook endpoint URL with is [`http://localhost:4000/api/fb_webhook`](http://localhost:4000/api/fb_webhook) to the facebook APP. But the facebook app only allowd a secure callback URL (https). For this case, here I use [`Ngrok`](https://ngrok.com/) to get secure URL. 
  
  * Run `ngrok http 4000` and get the secure URL for base endpoint.
  * Add the webhook callback URL, `<ngrok_generated_URl>/api/fb_webhook` and the verify token that we generated earlier.
  * Adding the callback URL will send HTTP request to our application and verify the webhook token.
  * After the verification, Bot will setup the [`Messenger Profile`](https://developers.facebook.com/docs/messenger-platform/reference/messenger-profile-api) for the page
 
### Boom!
You are ready to go! 

### Ready to run in production? 
Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
