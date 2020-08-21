defmodule Birdcage.Dashboard do
  @moduledoc """
  A Flagger Dashboard.
  """

  @topic inspect(__MODULE__)

  import Ecto.Query, warn: false
  alias Birdcage.{Deployment, Event, Repo}

  ### Deployments

  @doc """
  Returns the list of deployments.

  ## Examples

      iex> list_deployments()
      [%Deployment{}, ...]

  """
  def list_deployments do
    Repo.all(Deployment)
  end

  @doc """
  Gets a single deployment.

  Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

  ## Examples

      iex> get_deployment!(123)
      %Deployment{}

      iex> get_deployment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deployment!(id), do: Repo.get!(Deployment, id)

  @doc """
  Gets a single deployment.

  Returns nil if no result was found.

  ## Examples

      iex> get_deployment!(123)
      %Deployment{}

      iex> get_deployment!(456)
      nil

  """
  def get_deployment(id), do: Repo.get(Deployment, id)

  @doc """
  Creates a deployment.

  ## Examples

      iex> create_deployment(%{field: value})
      {:ok, %Deployment{}}

      iex> create_deployment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deployment(attrs \\ %{}) do
    Deployment.changeset(attrs)
    |> Repo.insert()
    |> broadcast([:deployment, :created])
  end

  @doc """
  Updates a deployment.

  ## Examples

      iex> update_deployment(deployment, %{field: new_value})
      {:ok, %Deployment{}}

      iex> update_deployment(deployment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deployment(%Deployment{} = deployment, attrs) do
    deployment
    |> Deployment.changeset(attrs)
    |> Repo.update()
    |> broadcast([:deployment, :updated])
  end

  @doc """
  Deletes a deployment.

  ## Examples

      iex> delete_deployment(deployment)
      {:ok, %Deployment{}}

      iex> delete_deployment(deployment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deployment(%Deployment{} = deployment) do
    deployment
    |> Repo.delete()
    |> broadcast([:deployment, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deployment changes.

  ## Examples

      iex> change_deployment(deployment)
      %Ecto.Changeset{data: %Deployment{}}

  """
  def change_deployment(%Deployment{} = deployment, attrs \\ %{}) do
    Deployment.changeset(deployment, attrs)
  end

  @doc """
  Get current value for id or insert value.
  """
  def fetch_deployment(%{"name" => _name, "namespace" => _namespace} = attrs) do
    changeset = Deployment.changeset(attrs)

    case get_deployment(changeset.changes.id) do
      nil -> Repo.insert(changeset)
      result -> {:ok, result}
    end
  end

  def toggle_rollout(id) do
    deployment = get_deployment!(id)
    update_deployment(deployment, %{allow_rollout: not deployment.allow_rollout})
  end

  def toggle_promotion(id) do
    deployment = get_deployment!(id)
    update_deployment(deployment, %{allow_promotion: not deployment.allow_promotion})
  end

  @doc """
  Update the last confirm rollout timestamp
  """
  def touch_confirm_rollout(%Deployment{} = deployment) do
    update_deployment(deployment, %{confirm_rollout_at: DateTime.utc_now()})
  end

  @doc """
  Update the last confirm promotion timestamp
  """
  def touch_confirm_promotion(%Deployment{} = deployment) do
    update_deployment(deployment, %{confirm_promotion_at: DateTime.utc_now()})
  end

  def allow_rollout?(%Deployment{allow_rollout: true}), do: :ok
  def allow_rollout?(%Deployment{allow_rollout: false}), do: {:error, :forbidden}

  def allow_promotion?(%Deployment{allow_promotion: true}), do: :ok
  def allow_promotion?(%Deployment{allow_promotion: false}), do: {:error, :forbidden}

  ### Events

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events(count \\ 10) do
    Event
    |> Repo.all()
    |> Enum.sort_by(& &1.inserted_at, {:desc, DateTime})
    |> Enum.take(count)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Gets a single event.

  Returns nil if no result was found.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      nil

  """
  def get_event(id), do: Repo.get(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}, opts \\ []) do
    Event.changeset(attrs)
    |> Repo.insert(opts)
    |> broadcast([:event, :created])
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs, opts \\ []) do
    event
    |> Event.changeset(attrs)
    |> Repo.update(opts)
    |> broadcast([:event, :updated])
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    event
    |> Repo.delete()
    |> broadcast([:event, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  ### PubSub
  def subscribe do
    Phoenix.PubSub.subscribe(Birdcage.PubSub, @topic)
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(Birdcage.PubSub, @topic <> "#{id}")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Birdcage.PubSub, @topic, {__MODULE__, event, result})

    Phoenix.PubSub.broadcast(
      Birdcage.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end
end
