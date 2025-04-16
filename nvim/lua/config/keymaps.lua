-- Keymaps for moving to beginning/end of line
vim.keymap.set('i', '<C-a>', '<Home>', { desc = 'Go to beginning of line' })
vim.keymap.set('i', '<C-s>', '<End>', { desc = 'Go to end of line' })
vim.keymap.set('n', '<C-a>', '0', { desc = 'Go to beginning of line' })
vim.keymap.set('n', '<C-s>', '$', { desc = 'Go to end of line' })
vim.keymap.set('v', '<C-a>', '0', { desc = 'Go to beginning of line' })
vim.keymap.set('v', '<C-s>', '$', { desc = 'Go to end of line' })

vim.keymap.set('n', 'q', 'b', { desc = 'Go backwards a word' })
vim.keymap.set('v', 'q', 'b', { desc = 'Go backwards a word' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
