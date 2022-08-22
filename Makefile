.PHONY: fmt
fmt:
	stylua --config-path stylua.toml --glob 'lua/**/*.lua' -- lua

.PHONY: lint
lint:
	luacheck ./lua

.PHONY: test
test:
	vusted --output=gtest --pattern=.spec ./lua

.PHONY: prepare
prepare:
	if [ ! -e "./tmp/nvim-treesitter" ]; then git clone git@github.com:nvim-treesitter/nvim-treesitter ./tmp/nvim-treesitter; fi

