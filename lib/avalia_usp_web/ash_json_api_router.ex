defmodule AvaliaUspWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [AvaliaUsp.Accounts, AvaliaUsp.Universidades, AvaliaUsp.Professores],
    open_api: "/open_api"
end
