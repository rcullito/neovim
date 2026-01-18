return {
  {
    name = "leap.nvim",
    url = "https://codeberg.org/andyg/leap.nvim.git",
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap forward" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap backward" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from window" },
    },
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s",  "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S",  "<Plug>(leap-backward)")
      vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
    end,
  },
}
