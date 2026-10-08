require("git"):setup {
    order = 1500,
}

require("zoxide"):setup {
    update_db = true,
}

-- Hide file permissions in the status bar.
Status.perm = function() return "" end

-- Hide the percentage in the status bar, keeping the position counter.
Status.percent = function() return "" end

require("full-border"):setup()

require("folder-rules"):setup()
