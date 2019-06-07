defmodule DscrumWeb.Helpers.PageList do
  use Bitwise


  def get_range(inicio, fin) do
    numbers = inicio..fin
    Enum.to_list(numbers)
  end

  def get_page_list(totalPages, page, maxLength) do

    sideWidth = if (maxLength < 9), do: 1, else: 2

    leftWidth = bsr((maxLength - sideWidth*2 - 3), 1)
    rightWidth = bsr((maxLength - sideWidth*2 - 2), 1)


    if (totalPages <= maxLength) do
        get_range(1, totalPages);
    else
      if (page <= maxLength - sideWidth - 1 - rightWidth) do
        get_range(1, maxLength-sideWidth-1) ++ [0] ++ get_range(totalPages-sideWidth+1, totalPages)
      else
        if (page >= totalPages - sideWidth - 1 - rightWidth) do
          get_range(1, sideWidth) ++ [0] ++ get_range(totalPages - sideWidth - 1 - rightWidth - leftWidth, totalPages)
        else
          get_range(1, sideWidth) ++ [0] ++ get_range(page - leftWidth, page + rightWidth + 2) ++ [0] ++ get_range(totalPages-sideWidth+1, totalPages)
        end
      end
    end
  end

end
