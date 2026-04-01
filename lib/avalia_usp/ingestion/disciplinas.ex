defmodule AvaliaUsp.Ingestion.Disciplinas do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Ingestion

  actions do
    action :scrape_discplinas, {:array, :string} do
      run AvaliaUsp.Ingestion.Actions.ScrapeDiscplinas
    end
  end
end
