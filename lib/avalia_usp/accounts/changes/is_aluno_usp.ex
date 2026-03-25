defmodule AvaliaUsp.Accounts.Changes.IsAlunoUsp do
  use Ash.Resource.Change

  @usp_email_domain "@usp.br"

  def change(changeset, opts, _context) do
    Ash.Changeset.before_action(changeset, fn changeset ->
      email = Ash.Changeset.get_argument(changeset, :email) |> to_string()

      if String.ends_with?(email, @usp_email_domain) do
        Ash.Changeset.force_change_attribute(changeset, :is_aluno_usp?, true)
      else
        changeset
      end
    end)
  end
end
