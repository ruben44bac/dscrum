defmodule Dscrum.AuthCommand do
  defstruct [
    :username,
    :password
  ]
  use ExConstructor
end
