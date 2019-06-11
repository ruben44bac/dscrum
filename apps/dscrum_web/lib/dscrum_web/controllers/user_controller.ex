defmodule DscrumWeb.UserController do
  use DscrumWeb, :controller
  alias Dscrum.AuthCommand
  alias Dscrum.UserHandler
  alias Dscrum.UserSchema
  # alias Dscrum.PagedCommand
  # alias DscrumWeb.Helpers.PageList


  plug :check_auth when action in [:index, :show, :new, :create, :edit, :update, :delete]



  defp check_auth(conn, _args) do

    if user_id = get_session(conn, :current_user_id) do

      case Dscrum.Guardian.decode_and_verify(get_session(conn, :token)) do
        {:ok, _claims} ->
          current_user = UserHandler.get_user!(user_id)
          conn
          |> assign(:current_user, current_user)
        {:error, _invalid} ->
          conn
          # |> put_flash(:error, "Inicia sesion para continuar.")
          |> redirect(to: "/login")
          |> halt()
      end

    else
      conn
      # |> put_flash(:error, "Inicia sesion para continuar.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def index(conn, _params) do
    # params =
    #   if Map.get(params, "index") == nil or Map.get(params, "size") == nil do
    #     %{"index" => "0", "size" => "5"}
    #   else
    #     params
    #   end


    # params =
    #   params
    #   |> PagedCommand.new

    # respuesta = UserHandler.list_user(params)

    # {number_size, _} = Integer.parse(params.size)
    # {number_index, _} = Integer.parse(params.index)

    # paginado = PageList.get_page_list(respuesta.total_pages, number_index, 7)

    # result = %{
    #   records: respuesta.records,
    #   total_records: respuesta.total_records,
    #   total_pages: respuesta.total_pages,
    #   page_number: number_index,
    #   page_size: number_size,
    #   paginado: paginado
    # }
    # render(conn, "index_socket.html", result: result)
    render(conn, "index_socket.html", csrf_token: get_csrf_token())
  end

  def new(conn, _params) do
    changeset = UserSchema.changeset(%UserSchema{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

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

  def create(conn, %{"user_schema" => user_schema}) do

    user_schema =
      if upload = user_schema["foto"] do

        with File.exists?(upload.path) do
          file = File.read!(upload.path)
          conve_base64 = Base.encode64(file)

          user_schema
          |> Map.put("image", conve_base64)
        end

      else

        user_schema
        |> Map.put("image", nil)
      end

    case UserHandler.create_validate(user_schema) do
      {:ok, _} ->
        conn
        # |> put_flash(:info, "Picture created successfully.")
        |> redirect(to: Routes.user_path(conn, :index, %{"index" => 0, "size" => 5}))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def signup(conn, attrs) do
    case UserHandler.create_validate(attrs) do
      {:ok, _} -> json conn, %{data: "Usuario creado con éxito"}
      {:error, mensaje} -> json conn, %{error: mensaje}
    end
  end

  def show(conn, _attrs) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserHandler.get_user!(id)
    changeset = UserSchema.changeset(user, %{})
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_schema" => user_params}) do
    user = UserHandler.get_user!(id)

    user_params =
      if upload = user_params["foto"] do

        with File.exists?(upload.path) do
          file = File.read!(upload.path)
          conve_base64 = Base.encode64(file)

          user_params
          |> Map.put("image", conve_base64)
        end

      else

        user_params
        |> Map.put("image", nil)
      end

    case UserHandler.update_validate(user, user_params) do
      {:ok, _user} ->
        conn
        # |> put_flash(:info, "Movie updated successfully.")
        |> redirect(to: Routes.user_path(conn, :index, %{"index" => 0, "size" => 5}))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def image(conn, attrs) do
    user = UserHandler.get_user(attrs["id"])
    {:ok, file} = File.read(user.image)
    conn
    |> send_download({:binary, file}, filename: "user.jpg")
  end

  def delete(conn, %{"id" => id}) do
    user = user = UserHandler.get_user!(id)
    {:ok, _user} = UserHandler.delete_user(user)

    conn
    # |> put_flash(:info, "Movie deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end


  def get_users_without_team(conn, _attrs) do
    user = UserHandler.list_user_sin_equipo()
    conn |> render("index.json", user: user)
  end

  def image_team(conn, attrs) do
    team = UserHandler.get_team(attrs["id"])
    {:ok, file} = File.read(team.logotype)
    conn
    |> send_download({:binary, file}, filename: "team.jpg")
  end

end
