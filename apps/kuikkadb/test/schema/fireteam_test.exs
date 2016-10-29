defmodule KuikkaDBTest.Fireteam do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.Fireteam, as: FireteamSchema

  setup do
    FireteamSchema.new(%{name: "test Team", description: "Testdescription"})

    {:ok, fireteam: FireteamSchema.one(name: "test Team")}
  end
  test "new fireteam", %{fireteam: fireteam} do

    assert fireteam.name == "test Team"
    assert fireteam.description == "Testdescription"
  end
  test "delete fireteam", %{fireteam: fireteam} do

    FireteamSchema.delete(fireteam)
    fireteam = FireteamSchema.one(name: "test Team")

    assert fireteam == nil
  end
  test "update fireteam", %{fireteam: fireteam} do

    FireteamSchema.update(fireteam, %{name: "new test", description: "nothing"})
    fireteam = FireteamSchema.one(name: "new test")

    assert fireteam.name == "new test"
    assert fireteam.description == "nothing"
  end
end
