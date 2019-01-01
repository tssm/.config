lua <<EOF
local pack = require('pack')
pack.set('https://github.com/gavocanov/vim-js-indent', 'javascript/start/indent', 'master')
pack.set('https://github.com/othree/yajs.vim.git', 'javascript/start/syntax ', 'master')
EOF

setlocal suffixesadd=.js
