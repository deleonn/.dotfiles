local avante = require("avante")

avante.setup({
  debug = false,
  provider = "ollama",
  providers = {
    ollama = {
      api_key_name = "",
      endpoint = "http://msi_th.home:11434",
      timeout = 30000,
      model = "devstral:latest",
      stream = true,
      extra_request_body = {
        options = {
          temperature = 0.75,
          num_ctx = 20480,
          keep_alive = "5m"
        },
      }
    }
  }
})
