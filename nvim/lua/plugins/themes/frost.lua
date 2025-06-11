return {
    "blckfrost/frost.nvim",
    priority = 1000,
    config = function()
        require("frost").setup()
    end,
}
