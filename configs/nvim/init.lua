-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- убрать стандартный intro Neovim
vim.opt.shortmess:append("I")

-- список плагинов через lazy.nvim
require("lazy").setup({
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- ASCII Arch Linux
      dashboard.section.header.val = {
        "                   -`                    ",
        "                  .o+`                   ",
        "                 `ooo/                   ",
        "                `+oooo:                  ",
        "               `+oooooo:                 ",
        "               -+oooooo+:                ",
        "             `/:-:++oooo+:               ",
        "            `/++++/+++++++:              ",
        "           `/++++++++++++++:             ",
        "          `/+++ooooooooooooo/`           ",
        "         ./ooosssso++osssssso+`          ",
        "        .oossssso-````/ossssss+`         ",
        "       -osssssso.      :ssssssso.        ",
        "      :osssssss/        osssso+++.       ",
        "     /ossssssss/        +ssssooo/-       ",
        "   `/ossssso+/:-        -:/+osssso+-     ",
        "  `+sso+:-`                 `.-/+oso:    ",
        " `++:.                           `-/+/   ",
        " .`                                 `/   ",
        "",
        "        Arch Linux · btw",
      }

      -- Кнопки
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰱼  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "󰁯  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Футер
      dashboard.section.footer.val = {
        "no systemd was harmed during startup",
      }

      -- Раскладка
      dashboard.opts.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- Показывать dashboard только если Neovim запущен без файлов
      if vim.fn.argc() == 0 then
        alpha.setup(dashboard.opts)
      end
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
})

