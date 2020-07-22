defmodule Birdcage.DashboardTest do
  @moduledoc false
  use ExUnit.Case

  alias Birdcage.{Dashboard, Deployment}

  describe "Dashboard" do
    setup do
      # clear the cache before each test
      Birdcage.Cache.stream()
      |> Enum.each(&Birdcage.Cache.delete(&1))
    end

    @valid_attrs %{
      "name" => "podinfo",
      "namespace" => "test",
      "phase" => "Progressing",
      "confirm_rollout_at" => ~U[2018-11-15 10:00:00Z]
    }

    @update_attrs %{
      "phase" => "Succeeded",
      "allow_rollout" => true,
      "confirm_rollout_at" => ~U[2018-11-16 10:01:00Z]
    }

    @invalid_attrs %{
      "name" => nil,
      "namespace" => 1234,
      "phase" => "BAD"
    }

    def deployment_fixture(attrs \\ %{}) do
      {:ok, deployment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dashboard.create_deployment()

      deployment
    end

    test "list_deployments/0 returns all deployments" do
      deployment = deployment_fixture()
      assert Dashboard.list_deployments() == [deployment]
    end

    test "get_deployment!/1 returns the deployment with given id" do
      deployment = deployment_fixture()
      assert Dashboard.get_deployment!(deployment.id) == deployment
    end

    test "create_deployment/1 with valid data creates a deployment" do
      assert {:ok, %Deployment{} = deployment} = Dashboard.create_deployment(@valid_attrs)

      assert deployment.id == "podinfo.test"
      assert deployment.name == "podinfo"
      assert deployment.namespace == "test"
      assert deployment.phase == "Progressing"
      assert deployment.allow_rollout == false
      assert deployment.confirm_rollout_at == ~U[2018-11-15 10:00:00Z]
    end

    test "create_deployment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.create_deployment(@invalid_attrs)
    end

    test "update_deployment/2 with valid data updates the deployment" do
      deployment = deployment_fixture()

      assert {:ok, %Deployment{} = deployment} =
               Dashboard.update_deployment(deployment, @update_attrs)

      assert deployment.phase == "Succeeded"
      assert deployment.allow_rollout == true
      assert deployment.confirm_rollout_at == ~U[2018-11-16 10:01:00Z]
    end

    test "update_deployment/2 with invalid data returns error changeset" do
      deployment = deployment_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboard.update_deployment(deployment, @invalid_attrs)
      assert deployment == Dashboard.get_deployment!(deployment.id)
    end

    test "delete_deployment/1 deletes the deployment" do
      deployment = deployment_fixture()
      assert {:ok, %Deployment{}} = Dashboard.delete_deployment(deployment)
      assert_raise Ecto.NoResultsError, fn -> Dashboard.get_deployment!(deployment.id) end
    end

    test "change_deployment/1 returns a deployment changeset" do
      deployment = deployment_fixture()
      assert %Ecto.Changeset{} = Dashboard.change_deployment(deployment)
    end

    test "fetch_deployment/1 with valid data returns the deployment with the derived id" do
      assert {:ok, %Deployment{} = deployment} = Dashboard.fetch_deployment(@valid_attrs)
      assert deployment.id == "podinfo.test"
    end

    test "fetch_deployment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.fetch_deployment(@invalid_attrs)
    end

    test "fetch_deployment/1 with valid and existing data returns the deployment with the derived id" do
      assert {:ok, %Deployment{} = created} = Dashboard.create_deployment(@valid_attrs)
      assert created.id == "podinfo.test"

      assert {:ok, %Deployment{} = updated} = Dashboard.toggle_rollout(created.id)

      assert {:ok, %Deployment{} = fetched} = Dashboard.fetch_deployment(@valid_attrs)
      assert fetched.id == "podinfo.test"

      assert fetched == updated
    end
  end
end
