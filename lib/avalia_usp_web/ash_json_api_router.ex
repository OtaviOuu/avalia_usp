defmodule AvaliaUspWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [AvaliaUsp.Accounts],
    open_api: "/open_api"
end
