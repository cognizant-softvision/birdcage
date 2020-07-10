defmodule Birdcage.DeploymentTest do
  @moduledoc false
  use ExUnit.Case

  describe "Deployment" do
    @valid_params %{
      "name" => "podinfo",
      "namespace" => "test",
      "phase" => "Progressing"
    }

    @invalid_params %{
      "name" => nil,
      "namespace" => 1234,
      "phase" => "BAD"
    }

    test "new with valid params is valid" do
      {:ok, deployment} = Birdcage.Deployment.new(@valid_params)

      assert deployment.key == "podinfo.test"
    end

    test "new with invalid params is invalid" do
      {:error, %Ecto.Changeset{} = changeset} = Birdcage.Deployment.new(@invalid_params)

      assert not changeset.valid?
    end
  end
end
