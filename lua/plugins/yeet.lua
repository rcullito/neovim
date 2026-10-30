return {
  {
    "samharju/yeet.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
    },
    version = "*",
    cmd = "Yeet",

    main = "yeet",
    opts = {},
    keys = {
      {
        "<leader>xt",
        function()
          require("yeet").execute()
        end,
        desc = "Yeet command",
      },
      {
        "<leader>xl",
        function()
          require("yeet").list_cmd()
        end,
        desc = "Yeet command palette",
      },
    },
  },
}
