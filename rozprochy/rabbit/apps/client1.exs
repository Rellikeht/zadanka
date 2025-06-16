Client.start_link("Ekipa 1")

["tlen", "tlen", "buty", "buty", "plecak", "plecak"]
|> Enum.map(fn item -> Client.order(item) end)
Client.wait_for_all()
