defmodule SpamzapperWeb.LayoutView do
  use SpamzapperWeb, :view

  def page_title title do
    "#{title} · Spamzapper"
  end
end
