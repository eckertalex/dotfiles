vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = vim.api.nvim_create_augroup("templates", {}),
    desc = "Load template file",
    callback = function(args)
        if vim.api.nvim_buf_line_count(args.buf) > 1 then
            return
        end

        local fname = vim.fs.basename(args.file)
        local ext = vim.fn.fnamemodify(args.file, ":e")
        local ft = vim.bo[args.buf].filetype

        local done = false
        for _, candidate in ipairs({ fname, ext, ft }) do
            if done then
                print("Done flag set, stopping search.")
                break
            end

            local tmpl_path =
                vim.fs.joinpath(vim.fn.stdpath("config"), "templates", string.format("%s.tmpl", candidate))
            local f = io.open(tmpl_path, "r")
            if f then
                vim.snippet.expand(f:read("*a"))
                f:close()
                done = true
            end
        end
    end,
})
