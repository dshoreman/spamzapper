defmodule SpamzapperWeb.Admin.MemberHTML do
  use SpamzapperWeb, :html

  import Scrivener.HTML

  embed_templates "member_html/*"
end
