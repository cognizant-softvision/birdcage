defmodule NebulexEctoRepoAdapterTest do
  use ExUnit.Case

  alias Birdcage.Event
  alias Birdcage.EventRepo

  import Ecto.Query

  @valid_attrs %{
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
      @valid_attrs
      |> Map.update("name", x, &"#{&1}##{x}")
      |> Event.changeset()
      |> EventRepo.insert()
    end
  end

  test "list" do
    event_results = EventRepo.all(Event)
    assert length(event_results) == 9
  end

  test "insert" do
    assert {:ok, %Event{} = result} =
             Event.changeset(@valid_attrs)
             |> EventRepo.insert()
  end

  test "insert / delete" do
    {:ok, %Event{} = event} =
      Event.changeset(@valid_attrs)
      |> EventRepo.insert()

    assert length(EventRepo.all(Event)) == 10

    EventRepo.delete(event)
    assert length(EventRepo.all(Event)) == 9
  end

  test "get by id" do
    [%Event{} = event] = EventRepo.all(Event) |> Enum.take(1)
    assert %Event{} = EventRepo.get!(Event, event.id)
  end

  test "where" do
    Event.changeset(%{@valid_attrs | "name" => "larry"})
    |> EventRepo.insert()

    result =
      Event
      |> where([x], x.namespace == "test" and x.name == "larry")
      |> EventRepo.all()
      |> List.first()

    assert result.name == "larry"
  end

  test "select where" do
    {:ok, %Event{} = event} =
      Event.changeset(%{@valid_attrs | "name" => "larry"})
      |> EventRepo.insert()

    result =
      Event
      |> where([x], x.namespace == "test" and x.name == "larry")
      |> select([x], x.id)
      |> EventRepo.all()
      |> List.first()

    assert result == event.id
  end

  test "select / update" do
    {:ok, result} =
      Event
      |> where([x], x.name == "podinfo#2")
      |> EventRepo.all()
      |> List.first()
      |> Event.changeset(%{name: "larry"})
      |> EventRepo.update()

    assert result.name == "larry"
  end
end
