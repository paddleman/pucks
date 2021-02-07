defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>View do
  use <%= inspect context.web_module %>, :view
  use JaSerializer.PhoenixView

  location  

  attributes [ <%= for {k, _} <- schema.attrs do %>: <%= k %>, <% end %>  ]

end