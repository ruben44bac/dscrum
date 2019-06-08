defmodule Dscrum.Helpers.TotalPaginas do

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t

      pos when pos > 0 ->
        t + 1

      _ ->
        t
    end
  end

  def total_paginas(count, numero_elementos) do
    ceiling(count / numero_elementos)
  end

end
