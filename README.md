# PhysicsSimCollisions

Wally and Rojo setup using the same source layout and Rojo version as TDS Revival.
The source folders and dependency lists start empty.

Run these commands from this folder:

```powershell
rokit install
wally install
rojo serve
```

In Roblox Studio, open the Rojo plugin and connect to `localhost:34872`.

| Local folder | Roblox location |
| --- | --- |
| `src/shared` | `ReplicatedStorage.Shared` |
| `src/server` | `ServerScriptService.Server` |
| `src/client` | `StarterPlayer.StarterPlayerScripts.Client` |
| `Packages` | `ReplicatedStorage.Packages` |
| `ServerPackages` | `ServerStorage.ServerPackages` |

Add shared packages under `[dependencies]` or server packages under
`[server-dependencies]` in `wally.toml`, then run `wally install` again.
Rokit selects this project's tool versions based on the current folder.
Wally creates the package directories once dependencies are added; Rojo also
works while these directories are absent.

To build a place file:

```powershell
rojo build -o PhysicsSimCollisions.rbxlx
```
