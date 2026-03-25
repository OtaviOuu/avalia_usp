defmodule AvaliaUsp.Accounts do
  use Ash.Domain, otp_app: :avalia_usp, extensions: [AshAdmin.Domain, AshJsonApi.Domain]

  admin do
    show? true
  end

  resources do
    resource AvaliaUsp.Accounts.Token
    resource AvaliaUsp.Accounts.User
  end
end
