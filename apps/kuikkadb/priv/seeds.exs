alias KuikkaDB.Schema.{Role, Fireteam, Fireteamrole}

if is_nil(Role.one(name: "user")) do
  Role.new(%{name: "user", description: "Basic user"})
  Role.new(%{name: "kuikka", description: "Kuikka user"})
  Role.new(%{name: "admin", description: "Admin user"})
end

fireteam = case Fireteam.one(name: "none") do
  nil ->
    Fireteam.new(%{name: "none", description: "Not part of any fireteam"})
    Fireteam.one(name: "none")
  ft ->
    ft
end

if is_nil(Fireteamrole.one(name: "none", fireteam_id: fireteam.id)) do
  Fireteamrole.new(%{name: "none",
                     description: "No role in any fireteam",
                     is_leader: false,
                     fireteam: fireteam})
end
