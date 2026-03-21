defmodule AvaliaUsp.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        AvaliaUsp.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:avalia_usp, :token_signing_secret)
  end
end
