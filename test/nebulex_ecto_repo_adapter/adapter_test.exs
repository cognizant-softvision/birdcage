defmodule NebulexEctoRepoAdapterTest do
  use ExUnit.Case

  alias Birdcage.Deployment
  alias Birdcage.Repo

  import Ecto.Query

  @valid_params %{
    "name" => "podinfo",
    "namespace" => "test",
    "phase" => "Progressing",
    "confirm_rollout_at" => ~U[2018-11-15 10:00:00Z]
  }

  setup do
    # clear the cache before each test
    Birdcage.Cache.stream()
    |> Enum.each(&Birdcage.Cache.delete(&1))

    # load test data
    for x <- 1..10 do
      @valid_params
      |> Map.update("name", x, &"#{&1}##{x}")
      |> Deployment.changeset()
      |> Repo.insert()
    end
  end

  test "list" do
    results = Repo.all(Deployment)

    assert length(results) == 10
  end

  test "insert" do
    assert {:ok, result} =
             Deployment.changeset(@valid_params)
             |> Repo.insert()

    assert result.id == "podinfo.test"
  end

  test "insert / delete" do
    {:ok, deployment} =
      Deployment.changeset(@valid_params)
      |> Repo.insert()

    assert length(Repo.all(Deployment)) == 11

    Repo.delete(deployment)
    assert length(Repo.all(Deployment)) == 10
  end

  test "get by id" do
    Repo.get!(Deployment, "podinfo#2.test")
  end

  test "where" do
    Deployment.changeset(%{@valid_params | "name" => "larry"})
    |> Repo.insert()

    result =
      Deployment
      |> where([x], x.namespace == "test" and x.name == "larry")
      |> Repo.all()
      |> List.first()

    assert result.name == "larry"
  end

  test "select where" do
    Deployment.changeset(%{@valid_params | "name" => "larry"})
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
