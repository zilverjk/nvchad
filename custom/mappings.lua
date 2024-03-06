local M = {}

M.disabled = {
  n = {
    ["<leader>ra"] = "",
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
  }
}

M.customs = {
  v = {
    ["J"] = { ":m '>+1<CR>gv=gv" },
    ["K"] = { ":m '<-2<CR>gv=gv" }
  },
  n = {
    ["d"] = { '"_d' },
    ["x"] = { '"_x' },

    ["<leader>rr"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

    ["<leader>bce"] = {
      function()
        require("nvchad.tabufline").closeOtherBufs()
      end,
      "Close other buffers except this"
    },

    ["<leader>bcl"] = {
      function()
        require("nvchad.tabufline").closeBufs_at_direction("left")
      end,
      "Close buffers to the left"
    },

    ["<leader>bcr"] = {
      function()
        require("nvchad.tabufline").closeOtherBufs("right")
      end,
      "Close buffers to the right"
    },
  }
}

M.nvimtree = {
  plugin = true,
  n = {
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" }
  }
}

M.nvterm = {
  plugin = true,
  n = {
    ["<C-t>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<C-]>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle floating term",
    },

    ["<C-g>"] = {
      function()
        require("nvterm.terminal").send("lg", "float")
      end,
      "Toggle terminal window for Lazygit",
      { noremap = true, silent = true }
    }
  },
  t = {
    ["<C-t>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<C-g>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term with Lazygit",
      { noremap = true, silent = true }
    },


    ["<C-]>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle floating term",
    },
  }
}

M.lspconfig = {
  plugin = true,
  n = {
    ["<leader>rn"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    }
  }
}

return M
