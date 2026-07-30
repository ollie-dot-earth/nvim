vim.keymap.set("n", "<leader>fw", vim.cmd.Ex, { desc = "File View" })


-- Split movement
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Swap to split left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Swap to split down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Swap to split up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Swap to split right" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", ":noh<CR>")

-- Split resizing
vim.keymap.set("n", "<A-h>", "<C-w><", { desc = "Resize split left" })
vim.keymap.set("n", "<A-j>", "<C-w>+", { desc = "Resize split down" })
vim.keymap.set("n", "<A-k>", "<C-w>-", { desc = "Resize split up" })
vim.keymap.set("n", "<A-l>", "<C-w>>", { desc = "Resize split right" })

-- always show virtual_text, but only brief info
-- show virtual line for current_line
vim.diagnostic.config({
    virtual_text = {
        format = function(diagnostic)
            return string.match(diagnostic.message, "(.-)\n")
        end,
    },
    virtual_lines = {
        current_line = true
    }
})

-- diagnostic keybinds
vim.keymap.set("n", "<leader>ew", vim.diagnostic.open_float, { desc = "Open [E]rror [W]indow" })

local show_errors = false
-- toggle showing virtual_lines
vim.keymap.set("n", "<leader>te", function()
    if show_errors then
        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    return string.match(diagnostic.message, "(.-)\n")
                end,
            },
            virtual_lines = {
                current_line = true
            }
        })
        show_errors = false
    else
        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    return string.match(diagnostic.message, "(.-)\n")
                end,
            },
            virtual_lines = false
        })
        show_errors = true
    end
end, { desc = "[T]oggle [E]rrors" })


vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")

vim.keymap.set("n", "<leader>w", ":w<CR>")

-- pack keybinds
vim.keymap.set("n", "<leader>pu", vim.pack.update, { desc = "[P]ack [U]pdate" })

-- remove leading and trailing whitespace
local function trim(s)
    return s:match("(.-)%s*%-*$")
end

vim.keymap.set("n", "<leader>ms", function()
    -- get current line(string) and row(int) in the buffer
    local line = trim(vim.api.nvim_get_current_line())
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

    -- make "-----------" seperator line at consitent length
    local seperator = string.rep("-", 79 - string.len(line))

    -- write line with seperator to current buffer at current cursor position
    vim.api.nvim_buf_set_lines(0, row - 1, row, true, { line .. " " .. seperator })
end, { desc = "[M]ake [S]eperator" })
