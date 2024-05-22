defmodule SpamzapperWeb.Admin.UserHTML do
  use SpamzapperWeb, :html

  import Scrivener.PhoenixView

  embed_templates "user_html/*"
end
