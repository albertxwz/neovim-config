--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: autocmds.lua
-- Description: Autocommand functions
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- General settings

-- Highlight on yank
autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = "1000"
        })
    end
})

-- Remove whitespace on save
autocmd("BufWritePre", {
    pattern = "",
    command = ":%s/\\s\\+$//e"
})

-- Auto format on save using the attached (optionally filtered) language servere clients
-- https://neovim.io/doc/user/lsp.html#vim.lsp.buf.format()
autocmd("BufWritePre", {
    pattern = "",
    command = ":silent lua vim.lsp.buf.format()"
})

-- Don"t auto commenting new lines
autocmd("BufEnter", {
    pattern = "",
    command = "set fo-=c fo-=r fo-=o"
})

autocmd("BufEnter", {
  pattern = "",
  command = "TSEnable highlight"
})

autocmd("Filetype", {
    pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua" },
    command = "setlocal shiftwidth=2 tabstop=2"
})

-- Set colorcolumn
autocmd("Filetype", {
    pattern = { "python", "rst", "c", "cpp" },
    command = "set colorcolumn=80"
})

autocmd("Filetype", {
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end
})

local lspconfig = require('lspconfig')
autocmd("FileType", {
  pattern = {"cpp", "c", "hpp", "h"},
  callback = function()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
      if client.name == 'clangd' then
        return
      end
    end
    lspconfig.clangd.setup{}
  end,
})

autocmd('FileType', {
  pattern = 'python',
  callback = function()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
      if client.name == 'pyright' then
        return
      end
    end
    lspconfig.pyright.setup{}
  end,
})
