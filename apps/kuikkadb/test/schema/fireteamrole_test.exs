defmodule KuikkaDBTest.Fireteamrole do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.Fireteamrole, as: FireteamroleSchema
  alias KuikkaDB.Schema.Fireteam, as: FireteamSchema

  setup do
    FireteamSchema.new(%{name: "test fireteam"})
    fireteam = FireteamSchema.one(name: "test fireteam")
    FireteamroleSchema.new(%{name: "test fireteamrole", description: "Testdescription",
                                 is_leader: false, fireteam: fireteam})

    {:ok, fireteamrole: FireteamroleSchema.one(name: "test fireteamrole")}
  end
  test "new fireteamrole", state do
    fireteamrole = state[:fireteamrole]

    assert fireteamrole.name == "test fireteamrole"
    assert fireteamrole.description == "Testdescription"
  end
  test "delete fireteamrole", state do
    fireteamrole = state[:fireteamrole]

    FireteamroleSchema.delete(fireteamrole)
    fireteamrole = FireteamroleSchema.one(name: "test fireteamrole")

    assert fireteamrole == nil
  end
  #test "update fireteam", state do
   # fireteamrole = state[:fireteamrole]
    #fireteam = FireteamSchema.one(name: "test fireteam")

    #fireteamrole = FireteamroleSchema.update(fireteamrole, %{name: "new test", description: "nothing"})
    #fireteamrole = FireteamroleSchema.one(name: "new test")

    #assert fireteamrole.name == "new test"
    #assert fireteamrole.description == "nothing"
  #end
end
