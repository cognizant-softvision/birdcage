defmodule NebulexEctoRepoAdapter do
  @moduledoc """
  Used as an Adapter in Repo modules.

  The Adapter implements the `Ecto.Adapter.Schema` and `Ecto.Adapter.Queryable` behaviours.

  To use the NebulexEctoRepoAdapter Adapter in your application, define a Repo like this:

      defmodule MyApp.Repo do
        use Ecto.Repo, otp_app: :my_app, adapter: NebulexEctoRepoAdapter
      end

  And tell the Adapter what Nebulex Cache it should use:

      config :my_app, NebulexEctoRepoAdapter, cache: MyApp.Cache
  """

  alias NebulexEctoRepoAdapter.Local.{MatchSpecification, TableStructure}

  @cache Application.compile_env(:birdcage, [NebulexEctoRepoAdapter, :cache])

  @behaviour Ecto.Adapter
  @behaviour Ecto.Adapter.Schema
  @behaviour Ecto.Adapter.Queryable

  @impl true
  defmacro __before_compile__(_opts), do: :ok

  @impl true
  def ensure_all_started(_config, _type), do: {:ok, []}

  @impl true
  def init(opts) do
    {:ok, repo} = Keyword.fetch(opts, :repo)
    child_spec = __MODULE__.Supervisor.child_spec(repo)

    {:ok, child_spec, %{repo: repo}}
  end

  @impl true
  def checkout(_, _, fun), do: fun.()

  ## Types

  @impl true
  def loaders(:binary_id, type), do: [Ecto.UUID, type]
  def loaders(:embed_id, type), do: [Ecto.UUID, type]
  def loaders(_primitive, type), do: [type]

  @impl true
  def dumpers(:binary_id, type), do: [type, Ecto.UUID]
  def dumpers(:embed_id, type), do: [type, Ecto.UUID]
  def dumpers(_primitive, type), do: [type]

  ## Queryable

  @impl true
  def prepare(:all, query), do: {:nocache, query}

  @impl true
  def execute(_, _, {:nocache, query}, params, _) do
    # query |> IO.inspect(label: :execute_query)
    # params |> IO.inspect(label: :execute_params)

    ets_match = MatchSpecification.build(query, params)

    results = @cache.all([ets_match])

    {length(results), results}
  end

  @impl true
  def stream(_adapter_meta, _query_meta, _query_cache, _params, _options) do
    nil
  end

  ## Schema

  @impl true
  def insert_all(_adapter_meta, _schema_meta, _header, _list, _on_conflict, _returning, _options) do
    {0, nil}
  end

  @impl true
  def autogenerate(:id), do: nil
  def autogenerate(:binary_id), do: Ecto.UUID.bingenerate()
  def autogenerate(:embed_id), do: Ecto.UUID.autogenerate()

  @impl true
  def insert(_, %{schema: schema}, fields, _on_conflict, _returning, opts) do
    schema_name = TableStructure.schema_name(schema)
    id = Keyword.fetch!(fields, :id)
    key = {schema_name, id}

    field_names = TableStructure.field_names(schema)
    changes = TableStructure.fields_to_tuple(field_names, fields)

    :ok = @cache.put(key, changes, opts)
    {:ok, []}
  end

  # Notice the list of changes is never empty.
  @impl true
  def update(_, %{schema: schema}, [_ | _] = changes, filters, [], opts) do
    schema_name = TableStructure.schema_name(schema)
    [primary_key] = schema.__schema__(:primary_key)
    [{^primary_key, id}] = filters
    key = {schema_name, id}

    updates = build_updates(schema, changes)

    {_get, _updated} =
      @cache.get_and_update(
        key,
        fn current_value ->
          new_value =
            updates
            |> Enum.reduce(current_value, fn update, acc ->
              put_elem(acc, elem(update, 0), elem(update, 1))
            end)

          {current_value, new_value}
        end,
        opts
      )

    {:ok, []}
  end

  @impl true
  def delete(_, %{schema: schema}, filters, opts) do
    schema_name = TableStructure.schema_name(schema)
    [primary_key] = schema.__schema__(:primary_key)
    [{^primary_key, id}] = filters
    key = {schema_name, id}

    :ok = @cache.delete(key, opts)
    {:ok, []}
  end

  defp build_updates(schema, fields) do
    field_names = TableStructure.field_names(schema)

    for {field_name, field_value} <- fields do
      position_fun = fn x -> x == field_name end
      position = Enum.find_index(field_names, position_fun)
      {position, field_value}
    end
  end
end
