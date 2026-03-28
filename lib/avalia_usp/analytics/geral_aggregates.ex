defmodule AvaliaUsp.Analytics.GeralAggregates do
  use Ash.Resource,
    otp_app: :avalia_usp,
    domain: AvaliaUsp.Analytics,
    data_layer: AshPostgres.DataLayer

  actions do
    action :geral_stats, :map do
      run fn input, _ ->
        %{rows: [[professores, disciplinas, avaliacoes]]} =
          AvaliaUsp.Repo.query!("""
          SELECT
            (SELECT COUNT(*) FROM professores) AS professores,
            (SELECT COUNT(*) FROM disciplinas) AS disciplinas,
            (SELECT COUNT(*) FROM avaliacaos) AS avaliacoes
          """)

        result = %{
          professores: professores,
          disciplinas: disciplinas,
          avaliacoes: avaliacoes
        }

        {:ok, result}
      end
    end
  end
end
