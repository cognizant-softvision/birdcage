defmodule NebulexEctoRepoAdapter.Local.TableStructure do
  @moduledoc """
  The Table Structure module contains various convenience functions to aid the transformation
  between Ecto Schemas (maps) and ETS entries (tuples). The primary key is moved to the head, in
  accordance with ETS conventions. Composite primary keys can not be accepted, however.

  See: https://github.com/evadne/etso/blob/develop/lib/etso/ets/table_structure.ex
  """

  def field_names(schema) do
    fields = schema.__schema__(:fields)
    primary_key = schema.__schema__(:primary_key)
    primary_key ++ (fields -- primary_key)
  end

  def fields_to_tuple(field_names, fields) do
    field_names
    |> Enum.map(&Keyword.get(fields, &1, nil))
    |> List.to_tuple()
  end

  def entries_to_tuples(field_names, entries) do
    for entry <- entries do
      fields_to_tuple(field_names, entry)
    end
  end
end
