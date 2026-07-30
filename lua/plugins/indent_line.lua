vim.pack.add({
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    { src = "https://github.com/lukas-reineke/virt-column.nvim" },
})

require("ibl").setup()

require("virt-column").setup({
    char = "▕"
})
