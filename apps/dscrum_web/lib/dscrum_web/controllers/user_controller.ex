defmodule DscrumWeb.UserController do
  use DscrumWeb, :controller
  alias Dscrum.AuthCommand
  alias Dscrum.UserHandler
  alias Dscrum.UserSchema

  plug :check_auth when action in [:index]



  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = UserHandler.get_user!(user_id)

      conn
      |> assign(:current_user, current_user)
    else
      conn
      # |> put_flash(:error, "Inicia sesion para continuar.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

	def index(conn, _params) do
      users = UserHandler.list_user()
      render(conn, "index.html", users: users)
  end

  # def show(conn, %{"id" => id}) do
  #   id_entero = String.to_integer(id)
  #   usuario = Cuentas.get_usuario(id_entero)
  #   render(conn, "show.html", usuario: usuario)
  # end

  def new(conn, _params) do
    changeset = UserSchema.changeset(%UserSchema{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  # def create(conn, %{"usuario" => parametros}) do
  #   IO.inspect(parametros)
  #   case Cuentas.registro_usuario(parametros) do
  #     {:ok, usuario} ->
  #       conn
  #         |> Autentificacion.acceso(usuario)
  #         |> put_flash(:info, "#{usuario.nombre} ha sido creado, amigo")
  #         |> redirect(to: Routes.usuario_path(conn, :index))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)

  #   end
  # end


  def login(conn, attrs) do
    resp = attrs
      |> AuthCommand.new
      |> UserHandler.login
    case resp do
      {:ok, token, _claims} ->
        conn
          |> render("jwt.json", jwt: token)
      {:error, mensaje} -> json conn, %{error: mensaje}
    end
  end

  def signup(conn, attrs) do
    case UserHandler.validate(attrs) do
      {:ok, _} -> json conn, %{data: "Usuario creado con éxito"}
      {:error, mensaje} -> json conn, %{error: mensaje}
    end
  end

  def show(conn, _attrs) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end

  def image(conn, attrs) do
    user = UserHandler.get_user(attrs["id"])
    {:ok, file} = File.read(user.image)
    conn
    |> send_download({:binary, file}, filename: "user.jpg")
  end

end
