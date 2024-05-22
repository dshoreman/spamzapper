defmodule SpamzapperWeb.Admin.MemberHTML do
  use SpamzapperWeb, :html

  import Scrivener.PhoenixView

  embed_templates "member_html/*"
end
