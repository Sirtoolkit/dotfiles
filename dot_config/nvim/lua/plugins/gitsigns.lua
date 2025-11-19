return {
	"lewis6991/gitsigns.nvim",
	-- Solo cargar si Git está instalado
	enabled = vim.fn.executable("git") == 1,
	-- Eventos estándar para cargar al abrir archivos
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▎" },
			topdelete = { text = "▎" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		-- La función on_attach se ejecuta cada vez que gitsigns se activa en un buffer
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]g", function()
				if vim.wo.diff then
					return "]g"
				end
				vim.schedule(function()
					gs.nav_hunk("next")
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Next Git hunk" })

			map("n", "[g", function()
				if vim.wo.diff then
					return "[g"
				end
				vim.schedule(function()
					gs.nav_hunk("prev")
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Previous Git hunk" })

			map("n", "[G", function()
				gs.nav_hunk("first")
			end, { desc = "First Git hunk" })
			map("n", "]G", function()
				gs.nav_hunk("last")
			end, { desc = "Last Git hunk" })

			-- Actions (Leader g)
			map("n", "<Leader>gl", gs.blame_line, { desc = "View Git blame" })
			map("n", "<Leader>gL", function()
				gs.blame_line({ full = true })
			end, { desc = "View full Git blame" })
			map("n", "<Leader>gp", gs.preview_hunk_inline, { desc = "Preview Git hunk" })
			map("n", "<Leader>gr", gs.reset_hunk, { desc = "Reset Git hunk" })
			map("n", "<Leader>gR", gs.reset_buffer, { desc = "Reset Git buffer" })
			map("n", "<Leader>gs", gs.stage_hunk, { desc = "Stage Git hunk" })
			map("n", "<Leader>gS", gs.stage_buffer, { desc = "Stage Git buffer" })
			map("n", "<Leader>gd", gs.diffthis, { desc = "View Git diff" })

			-- Visual Mode Actions (para resetear/stager partes seleccionadas)
			map("v", "<Leader>gr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Reset Git hunk" })

			map("v", "<Leader>gs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Stage Git hunk" })

			-- Text Objects (para usar 'dig' delete inner git, 'vig' select inner git)
			map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Inside Git hunk" })
		end,
	},
}
