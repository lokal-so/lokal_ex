defmodule Lokal do
  @moduledoc """
  A module for interacting with the Lokal service.
  """

  @server_min_version "1.0.0"

  defmodule Tunnel do
    @moduledoc """
    A module representing a tunnel.
    """

    @derive Jason.Encoder
    defstruct [
      :id,
      :name,
      :tunnel_type,
      :local_address,
      :server_id,
      :address_tunnel,
      :address_tunnel_port,
      :address_public,
      :address_mdns,
      :inspect,
      :options,
      :ignore_duplicate,
      :startup_banner
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t(),
            tunnel_type: String.t(),
            local_address: String.t(),
            server_id: String.t(),
            address_tunnel: String.t(),
            address_tunnel_port: integer(),
            address_public: String.t(),
            address_mdns: String.t(),
            inspect: boolean(),
            options: map(),
            ignore_duplicate: boolean(),
            startup_banner: boolean()
          }

    @doc """
    Creates a new Tunnel struct.
    """
    def new do
      %__MODULE__{}
    end

    @spec set_local_address(Lokal.Tunnel.t(), any()) :: Lokal.Tunnel.t()
    @doc """
    Sets the local address for the tunnel.
    """
    def set_local_address(tunnel, local_address) do
      %__MODULE__{tunnel | local_address: local_address}
    end

    @doc """
    Sets the tunnel type.
    """
    def set_tunnel_type(tunnel, tunnel_type) do
      %__MODULE__{tunnel | tunnel_type: tunnel_type}
    end

    @doc """
    Sets the inspection flag.
    """
    def set_inspection(tunnel, inspect) do
      %__MODULE__{tunnel | inspect: inspect}
    end

    @doc """
    Sets the LAN address.
    """
    def set_lan_address(tunnel, lan_address) do
      lan_address = String.trim_trailing(lan_address, ".local")
      %__MODULE__{tunnel | address_mdns: lan_address}
    end

    @doc """
    Sets the public address.
    """
    def set_public_address(tunnel, public_address) do
      %__MODULE__{tunnel | address_public: public_address}
    end

    @doc """
    Sets the name of the tunnel.
    """
    def set_name(tunnel, name) do
      %__MODULE__{tunnel | name: name}
    end

    @doc """
    Ignores duplicate tunnels.
    """
    def ignore_duplicate(tunnel) do
      %__MODULE__{tunnel | ignore_duplicate: true}
    end

    @doc """
    Shows the startup banner.
    """
    def show_startup_banner(tunnel) do
      %__MODULE__{tunnel | startup_banner: true}
    end

    @doc """
    Creates the tunnel.
    """
    def create(tunnel) do
      case HTTPoison.post("#{Lokal.base_url()}/api/tunnel/start", Jason.encode!(tunnel), headers()) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, %{"data" => data}} = Jason.decode(body)
          %{"AddressPublic" => public_address, "AddressMdns" => mdns_address, "ID" => id} = List.first(data)
          tunnel = %__MODULE__{tunnel | address_public: public_address, address_mdns: mdns_address, id: id}
          print_startup_banner(tunnel)
          {:ok, tunnel}

        {:error, %HTTPoison.Error{reason: reason}} ->
          {:error, reason}
      end
    end

    defp headers do
      [{"Content-Type", "application/json"}, {"X-Auth-Token", Lokal.token()}]
    end

    defp print_startup_banner(tunnel) do
      if tunnel.startup_banner do
        IO.puts("""
    __       _         _
   / /  ___ | | ____ _| |  ___  ___
  / /  / _ \| |/ / _  | | / __|/ _ \
 / /__| (_) |   < (_| | |_\__ \ (_) |
 \____/\___/|_|\_\__,_|_(_)___/\___/
        """)

        IO.puts("Minimum Lokal Client\t#{Lokal.server_min_version()}")
        IO.puts("Public Address\t\thttps://#{tunnel.address_public}")
        IO.puts("LAN Address\t\thttps://#{tunnel.address_mdns}.local")
      end
    end
  end

  @doc """
  Initializes a new Lokal client.
  """
  def new_default do
    %{
      base_url: "http://127.0.0.1:6174",
      token: nil
    }
  end

  @doc """
  Sets the base URL for the Lokal client.
  """
  def set_base_url(client, url) do
    %{client | base_url: url}
  end

  @doc """
  Sets the API token for the Lokal client.
  """
  def set_api_token(client, token) do
    %{client | token: token}
  end

  def base_url, do: Application.get_env(:lokal, :base_url, "http://127.0.0.1:6174")
  def token, do: Application.get_env(:lokal, :token, nil)
  def server_min_version, do: Application.get_env(:lokal, :server_min_version, @server_min_version)
end
