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
	use 'voldikss/vim-floaterm'

	-- appearance
	use 'arcticicestudio/nord-vim'
	use 'junegunn/seoul256.vim'
	use 'sheerun/vim-polyglot'
end)

require("mason").setup()
require("mason-lspconfig").setup()
-- automatically init Mason installed servers
-- see :h mason-lspconfig-automatic-server-setup
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
				vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
				vim.keymap.set('n', 'T', vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
				vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)

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

-- completion engine
local cmp = require("cmp")
local select_completion = function(down)
	return cmp.mapping(function(fallback)
		if cmp.visible() and down then
			cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
		elseif cmp.visible() and not down then
			cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
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
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-P>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
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

	" colorscheme
	let g:themes = ["seoul256", "seoul256-light", "nord"]
	let g:curr_index = 420

	function! ThemeSet()
		let curr_theme = g:themes[g:curr_index]
		execute 'colorscheme ' .. curr_theme

		if trim(system("echo \'tell application \"Terminal\" to return name of current settings of first window\' | osascript")) !=# curr_theme
			call system("echo \'tell application \"Terminal\" to set current settings of first window to settings set \"" . curr_theme . "\"\' | osascript")
		endif

		redraw
	endfunction

	function! ThemeInit()
		"if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
		"	let g:curr_index = 0
		"else
		"	let g:curr_index = 1
		"endif
		let g:curr_index = 0
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
	" fix 'set -o vi' conflict
	tnoremap <Esc><Esc> <C-\><C-N>

	" FZF
	" use universal-ctags
	let g:fzf_tags_command = 'uctags -R'
	nnoremap <leader>b :Buffers<CR>
	nnoremap <leader>f :Files<CR>
	nnoremap <leader>g :Rg<CR>

	" Nerdtree
	nnoremap <leader>q :call NERDTreeToggleAndRefresh()<CR>
	function! NERDTreeToggleAndRefresh()
		:NERDTreeToggle
		if g:NERDTree.IsOpen()
			:NERDTreeRefreshRoot
		endif
	endfunction

	" Tagbar
	nnoremap <leader>w :TagbarToggle f<CR>

	" Floatterm
	tnoremap § <C-\><C-n>:FloatermToggle<CR>
	nnoremap § <C-\><C-n>:FloatermToggle<CR>
]])
