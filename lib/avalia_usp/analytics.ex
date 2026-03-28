defmodule AvaliaUsp.Analytics do
  use Ash.Domain,
    otp_app: :avalia_usp

  resources do
    resource AvaliaUsp.Analytics.GeralAggregates do
      define :get_geral_aggregates, action: :geral_stats
    end
  end
end
