require('packer').startup(function(use)
	-- packer
	use 'wbthomason/packer.nvim'

	-- fzf
	use 'junegunn/fzf'
	use 'junegunn/fzf.vim'

	-- lsp
	use 'neovim/nvim-lspconfig'
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use {
		'hrsh7th/nvim-cmp',
		requires = {
			use 'hrsh7th/cmp-nvim-lsp',
			use 'hrsh7th/cmp-vsnip',
			use 'hrsh7th/vim-vsnip',
			use 'hrsh7th/cmp-path',
			use 'hrsh7th/cmp-nvim-lsp-signature-help',
		}
	}

	-- other
	use 'preservim/tagbar'
	use 'preservim/nerdtree'

	-- appearance
	use 'arcticicestudio/nord-vim'
	use 'junegunn/seoul256.vim'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	--use 'sheerun/vim-polyglot'
	use 'morhetz/gruvbox'
end)

require("nvim-treesitter.configs").setup {
	-- must be installed for treesitter to function
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

-- automatically init Mason installed servers
-- see :h mason-lspconfig-automatic-server-setup
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
	function(server_name)
		require("lspconfig")[server_name].setup {
			on_attach = function(client, bufnr)
				-- enable autoformatting on save if available
				if client.supports_method("textDocument/formatting") then
					vim.cmd("autocmd BufWritePre * lua vim.lsp.buf.format()")
				end

				-- setup keybindings
				local bufopts = { noremap = true, silent = false, buffer = bufnr }
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
				vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
				vim.keymap.set('n', 'S', vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
				-- show all diagnostics in new pane
				vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, opts)
				-- floating window for all diagnostics on current line (useful if inline error is too long)
				vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, opts)
				-- "code [a]ction" show available actions for diagnostics on current line
				vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
				vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

				-- show diagnostics in insert mode
				vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
					vim.lsp.diagnostic.on_publish_diagnostics, {
					update_in_insert = true,
					underline = false,
				}
				)
			end
		}
	end,
	-- optional overrides
}

---- status line diagnostics counter (see :h statusline) (not in vim.cmd section because string.format is faster and luaeval's not needed)
--vim.api.nvim_create_autocmd('DiagnosticChanged', {
--	callback = function(args)
--		local diagnostics = args.data.diagnostics
--		vim.opt.statusline = string.format("%%f%%=%%([%d]E [%d]W %%v %%P%%)",
--			#vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.ERROR } }),
--			#vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.WARN } })
--		)
--	end,
--})

-- completion engine keybindings
local cmp = require("cmp")
local select_completion = function(down)
	return cmp.mapping(function(fallback)
		if cmp.visible() and down then
			cmp.select_next_item() --{ behavior = cmp.SelectBehavior.Select })
		elseif cmp.visible() and not down then
			cmp.select_prev_item() --{ behavior = cmp.SelectBehavior.Select })
		else
			fallback()
		end
	end, { "i" })
end
cmp.setup({
	snippet = {
		-- required - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = select_completion(true),
		["<S-Tab>"] = select_completion(false),
		['<C-P>'] = cmp.mapping.abort(),
		--['<C-Space>'] = cmp.mapping.complete(),
		--['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'path' },
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
	}, {
		{ name = 'buffer' },
	}),
})

vim.cmd([[
	so ~/.vimrc

	set noruler

	" colorschemes
	let g:themes = ["seoul256-light", "seoul256", "gruvbox", "nord"]
	let g:gruvbox_contrast_dark = "soft"
	let g:curr_index = 420

	autocmd Signal SIGUSR1 call ThemeToggle()

	function! ThemeSet()
		let curr_theme = g:themes[g:curr_index]
		execute 'colorscheme ' .. curr_theme

		if trim(system("echo \'tell application \"Terminal\" to return name of current settings of first window\' | osascript")) !=# curr_theme
			set bg=dark
			if g:curr_index == 0
				set bg=light
			endif
			"call system("for pid in $(pgrep nvim);do kill -SIGUSR1 $pid; done") "does not work because it is recursive (we could filter current pid)
			call system("echo \'tell application \"Terminal\" to set current settings of first window to settings set \"" . curr_theme . "\"\' | osascript")
		endif

		redraw
	endfunction

	function! ThemeInit()
		let g:curr_index = 0
		"if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
		"	let g:curr_index = 0
		"endif
		call ThemeSet()
	endfunction

	function! ThemeToggle()
		if g:curr_index + 1 == len(g:themes)
			let g:curr_index = 0
		else
			let g:curr_index += 1
		endif
		call ThemeSet()
	endfunction

	call ThemeInit()
	nnoremap <leader>ç :call ThemeToggle()<CR>

	" reserve space for diagnostic icons
	set signcolumn=yes

	" Neovim terminal
	" start terminal on insert mode
	autocmd TermOpen * startinsert
	" don't show line numbers
	autocmd TermOpen * setlocal nonumber norelativenumber
	tnoremap <C-J> <C-\><C-N><C-W>j
	tnoremap <C-K> <C-\><C-N><C-W>k
	tnoremap <C-H> <C-\><C-N><C-W>h
	tnoremap <C-L> <C-\><C-N><C-W>l
	tnoremap <C-G> <C-\><C-N>
	function! TerminalToggle()
		let l:num = bufnr("term://")
		if l:num < 0
			execute "belowright 10sp \| term"
		else
			execute "belowright 10sp \| b " . l:num
		endif
	endfunction
	nnoremap <leader>l :call TerminalToggle()<CR>

	" FZF
	" use universal-ctags
	let g:fzf_tags_command = 'uctags -R'
	nnoremap <leader>u :Buffers<CR>
	nnoremap <leader>i :Files<CR>
	nnoremap <leader>o :Rg<CR>
	autocmd FileType fzf silent! tunmap <buffer> <C-J>
	autocmd FileType fzf silent! tunmap <buffer> <C-K>
	autocmd FileType fzf tnoremap <buffer> <Esc> <C-G>

	" Nerdtree
	nnoremap <leader>j :call NERDTreeToggleAndRefresh()<CR>
	function! NERDTreeToggleAndRefresh()
		:NERDTreeToggle
		if g:NERDTree.IsOpen()
			:NERDTreeRefreshRoot
		endif
	endfunction

	" Tagbar
	nnoremap <leader>k :TagbarToggle<CR>

	" Go syntax that's not enabled by default (not required if using treesitter)
	"let g:go_highlight_array_whitespace_error = 1
	"let g:go_highlight_chan_whitespace_error = 1
	"let g:go_highlight_extra_types = 1
	"let g:go_highlight_space_tab_error = 1
	"let g:go_highlight_trailing_whitespace_error = 1
	"let g:go_highlight_operators = 1
	"let g:go_highlight_functions = 1
	"let g:go_highlight_function_parameters = 1
	"let g:go_highlight_function_calls = 1
	"let g:go_highlight_types = 1
	"let g:go_highlight_fields = 1
	"let g:go_highlight_build_constraints = 1
	"let g:go_highlight_generate_tags = 1
	"let g:go_highlight_string_spellcheck = 1
	"let g:go_highlight_format_strings = 1
	"let g:go_highlight_variable_declarations = 1
	"let g:go_highlight_variable_assignments = 1
]])
