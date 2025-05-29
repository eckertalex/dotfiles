return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
		config = function()
			local servers = {
				astro = {},
				cssls = {},
				cssmodules_ls = {},
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
					},
					on_attach = function()
						vim.keymap.set("", "<leader>cx", "<cmd>LspEslintFixAll<cr>", { desc = "LspEslintFixAll" })
					end,
				},
				elixirls = {},
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = false,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = {
								"-.git",
								"-.vscode",
								"-.idea",
								"-.vscode-test",
								"-node_modules",
							},
							semanticTokens = true,
						},
					},
				},
				graphql = {},
				html = {},
				jsonls = {
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
					end,
					settings = {
						format = {
							json = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							telemetry = {
								enable = false,
							},
							diagnostics = {
								disable = {
									"missing-fields",
								},
							},
							hint = {
								enable = true,
							},
						},
					},
				},
				marksman = {},
				sqls = {},
				tailwindcss = {},
				vtsls = {
					settings = {
						typescript = {
							inlayHints = {
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								variableTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								enumMemberValues = { enabled = true },
							},
						},
					},
				},
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_enable = true,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"gofumpt",
					"goimports",
					"markdownlint",
					"prettier",
					"shfmt",
					"stylua",
				},
				automatic_enable = true,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					---@module 'snacks'
					vim.keymap.set(
						"n",
						"gd",
						-- vim.lsp.buf.definition,
						function()
							Snacks.picker.lsp_definitions()
						end,
						{ buffer = event.buf, desc = "vim.lsp.buf.definition" }
					)

					vim.keymap.set(
						"n",
						"grr",
						-- vim.lsp.buf.references,
						function()
							Snacks.picker.lsp_references()
						end,
						{ buffer = event.buf, desc = "vim.lsp.buf.references" }
					)
				end,
			})
		end,
	},
}
