defmodule NebulexEctoRepoAdapterTest do
  use ExUnit.Case

  alias Birdcage.{Deployment, Event}
  alias Birdcage.Repo

  import Ecto.Query

  @valid_dashboard_params %{
    "name" => "podinfo",
    "namespace" => "test",
    "phase" => "Progressing",
    "confirm_rollout_at" => ~U[2018-11-15 10:00:00Z]
  }

  @valid_event_attrs %{
    "name" => "podinfo",
    "namespace" => "test",
    "phase" => "Failed",
    "metadata" => %{
      "eventMessage" => "Canary failed! Scaling down rollout-test.flagger",
      "eventType" => "Warning",
      "timestamp" => "1597351286250"
    }
  }

  setup do
    # clear the cache before each test
    Birdcage.Cache.stream()
    |> Enum.each(&Birdcage.Cache.delete(&1))

    # load test data
    for x <- 1..9 do
      @valid_dashboard_params
      |> Map.update("name", x, &"#{&1}##{x}")
      |> Deployment.changeset()
      |> Repo.insert()

      @valid_event_attrs
      |> update_in(
        ["metadata", "timestamp"],
        &String.replace(&1, "0", to_string(x), global: false)
      )
      |> Event.changeset()
      |> Repo.insert()
    end
  end

  test "list" do
    deployment_results = Repo.all(Deployment)
    assert length(deployment_results) == 9

    event_results = Repo.all(Event)
    assert length(event_results) == 9
  end

  test "insert" do
    assert {:ok, result} =
             Deployment.changeset(@valid_dashboard_params)
             |> Repo.insert()

    assert result.id == "podinfo.test"
  end

  test "insert / delete" do
    {:ok, deployment} =
      Deployment.changeset(@valid_dashboard_params)
      |> Repo.insert()

    assert length(Repo.all(Deployment)) == 10

    Repo.delete(deployment)
    assert length(Repo.all(Deployment)) == 9
  end

  test "get by id" do
    assert %Deployment{} = Repo.get!(Deployment, "podinfo#2.test")

    [%Event{} = event] = Repo.all(Event) |> Enum.take(1)
    assert %Event{} = Repo.get!(Event, event.id)
  end

  test "where" do
    Deployment.changeset(%{@valid_dashboard_params | "name" => "larry"})
    |> Repo.insert()

    result =
      Deployment
      |> where([x], x.namespace == "test" and x.name == "larry")
      |> Repo.all()
      |> List.first()

    assert result.name == "larry"
  end

  test "select where" do
    Deployment.changeset(%{@valid_dashboard_params | "name" => "larry"})
    |> Repo.insert()

    result =
      Deployment
      |> where([x], x.namespace == "test" and x.name == "larry")
      |> select([x], x.id)
      |> Repo.all()
      |> List.first()

    assert result == "larry.test"
  end

  test "select / update" do
    {:ok, result} =
      Deployment
      |> where([x], x.name == "podinfo#2")
      |> Repo.all()
      |> List.first()
      |> Deployment.changeset(%{name: "larry"})
      |> Repo.update()

    assert result.name == "larry"
  end
end
