require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'junegunn/fzf'
	use 'junegunn/fzf.vim'
	use 'junegunn/seoul256.vim'
	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },

			-- Snippets (actually unused but will give off an error if not included)
			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
		}
	}
	use 'preservim/tagbar'
	use 'preservim/nerdtree'
	use 'arcticicestudio/nord-vim'
end)

local lsp = require('lsp-zero')
lsp.preset('recommended')
-- remove snippets from suggestions
lsp.setup_nvim_cmp({
	sources = {
		{ name = 'path' },
		{ name = 'nvim_lsp', keyword_length = 3 },
		{ name = 'buffer', keyword_length = 3 },
	}
})
lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = false,
	float = false,
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
		if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
			let g:curr_index = 0
		else
			let g:curr_index = 1
		endif
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

	" use universal-ctags
	let g:fzf_tags_command = 'uctags -R'
	nnoremap <leader>b :Buffers<CR>
	nnoremap <leader>f :Files<CR>
	nnoremap <leader>t :Tags<CR>
	nnoremap <leader>r :Rg<CR>
	" fix floating window esc delay
	tnoremap <leader>g <C-G>
	tnoremap <leader>v <C-V>
	tnoremap <leader>x <C-X>

	" Tagbar
	nnoremap <leader>w :TagbarToggle f<CR>

	" Nerdtree
	nnoremap <leader>q :NERDTreeToggle<CR>

	" format on save
	autocmd BufWritePre * lua vim.lsp.buf.format()
]])
