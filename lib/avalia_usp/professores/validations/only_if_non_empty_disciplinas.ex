defmodule AvaliaUsp.Professores.Validations.OnlyIfNonEmptyDisciplinas do
  use Ash.Resource.Validation

  def validate(changeset, opts, _ctx) do
    disciplinas = Ash.Changeset.get_data(changeset, :disciplinas) || []
    dbg(disciplinas)

    if length(disciplinas) > 0 do
      {:ok, changeset}
    else
      {:error, field: :disciplina_id, message: "Deve conter pelo menos uma disciplina"}
    end
  end
end
