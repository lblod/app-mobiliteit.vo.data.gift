defmodule Dispatcher do
  use Matcher

  define_accept_types [
    text: [ "text/*" ],
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  match "/images/*path", %{ accept: %{ json: true } } do
    Proxy.forward conn, path, "http://resource/images/"
  end

  match "/images/*path", %{} do
    Proxy.forward conn, path, "http://filehost/images/"
  end

  #  match _, %{} do
  #   send_resp( conn, 404, "Route not found." )
  # end
  last_match()
end
