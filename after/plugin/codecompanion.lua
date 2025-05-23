local companion = require("codecompanion")

companion.setup({
  display = {
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ", -- Prompt used for interactive LLM calls
      provider = "default", -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
      opts = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
      },
    },
  },
  adapters = {
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        env = {
          url = "http://msi_th.local:11434",
          api_key = "OLLAMA_API_KEY",
        },
        headers = {
          ["Content-Type"] = "application/json",
          ["Authorization"] = "Bearer ${api_key}",
        },
        parameters = {
          sync = true,
        },
        schema = {
          model = {
            default = "qwen2.5-coder:32b",
            -- default = "codegemma:latest",
          },
          num_ctx = {
            default = 20000,
          },
        },
      })
    end,
  },
  strategies = {
      chat = {
        adapter = "ollama",
      },
      inline = {
        adapter = "ollama",
      }
  },
})

