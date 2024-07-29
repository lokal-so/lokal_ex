# LokalEx

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lokal_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lokal_ex, "~> 0.1.0"}
  ]
end
```

```elixir
tunnel = Lokal.Tunnel.new()
  |> Lokal.Tunnel.set_name("my-web-app")
  |> Lokal.Tunnel.set_local_address("localhost:4000")
  |> Lokal.Tunnel.set_tunnel_type("http")
  |> Lokal.Tunnel.set_lan_address("snake.local")
  |> Lokal.Tunnel.set_inspection(true)
  |> Lokal.Tunnel.show_startup_banner()
  |> Lokal.Tunnel.create()
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/lokal_ex>.

