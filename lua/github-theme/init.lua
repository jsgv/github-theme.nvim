local converter = require('github-theme.converter.converter')

local M = {}

local function get_theme(theme)
    local filename = 'data/colors/'.. theme ..'.json'
    local filepath = vim.api.nvim_get_runtime_file(filename, false)[1]

    if not filepath then
        return nil
    end

    if vim.fn.filereadable(filepath) == 0 then
        return nil
    end

    return vim.fn.json_decode(vim.fn.readfile(filepath))
end

local function highlight(group, styles)
    if styles.link then
        vim.cmd("highlight! link " .. group .. " " .. styles.link)
    else
        local gui = styles.gui and 'gui='..styles.gui or 'gui=NONE'
        local sp = styles.sp and 'guisp='..styles.sp or 'guisp=NONE'
        local fg = styles.fg and 'guifg='..styles.fg or 'guifg=NONE'
        local bg = styles.bg and 'guibg='..styles.bg or 'guibg=NONE'

        vim.api.nvim_command('highlight! '..group..' '..gui..' '..sp..' '..fg..' '..bg)
    end
end

function M.rgba_to_table (color_line)
    local rgb_colors = {}
	local is_rgba = false

	local rgb = color_line:gmatch('rgb%(%d+%%?,%s?%d+%%?,%s?%d+%%?%)')()
	if not rgb then
		rgb = color_line:gmatch('rgba%(%d+%%?,%s?%d+%%?,%s?%d+%%?,%s?[.%d]+%)')()
		is_rgba = true
	end

	for _, color_part in ipairs(vim.split(
        is_rgba and rgb:gsub('rgba%(', ''):gsub('%);?', '')
            or rgb:gsub('rgb%(', ''):gsub('%);?', ''),
            ','
	)) do
		rgb_colors[#rgb_colors + 1] = tonumber(color_part)
	end

    return  rgb_colors
end

function M.from_RGBA_to_Hex(color_line, background)
    local rgb_colors = M.rgba_to_table(color_line)

    local alpha_calc = (1 - rgb_colors[4])

    local red   = rgb_colors[1] * rgb_colors[4] + background[1] * alpha_calc
    local green = rgb_colors[2] * rgb_colors[4] + background[2] * alpha_calc
    local blue  = rgb_colors[3] * rgb_colors[4] + background[3] * alpha_calc

    -- Round values correctly
    red = math.floor(red + 0.5)
    green = math.floor(green + 0.5)
    blue = math.floor(blue + 0.5)

    local hex_color = converter.RGB_to_Hex(red, green, blue)

    return hex_color
end

local function code_syntax(theme_name, theme)
    local function themes(options) return options[theme_name]  end
    local scale = theme.scale

    local bg = converter.Hex_to_RGB(theme.canvas.default)

    local color_red = themes({
        light              = scale.red[6],
        light_colorblind   = scale.red[6],
        dark               = scale.red[4],
        dark_colorblind    = scale.red[4],
        dark_dimmed        = scale.red[4],
        dark_high_contrast = scale.red[4]
    })

    local color_purple = themes({
        light              = scale.purple[6],
        light_colorblind   = scale.purple[6],
        dark               = scale.purple[3],
        dark_colorblind    = scale.purple[3],
        dark_dimmed        = scale.purple[3],
        dark_high_contrast = scale.purple[3],
    })

    local color_blue = themes({
        light              = scale.blue[7],
        light_colorblind   = scale.blue[7],
        dark               = scale.blue[3],
        dark_colorblind    = scale.blue[3],
        dark_dimmed        = scale.blue[3],
        dark_high_contrast = scale.blue[3],
    })

    local color_blue_2 = themes({
        light              = scale.blue[9],
        light_colorblind   = scale.blue[9],
        dark               = scale.blue[2],
        dark_colorblind    = scale.blue[2],
        dark_dimmed        = scale.blue[2],
        dark_high_contrast = scale.blue[2],
    })

    local color_orange = themes({
        light              = scale.orange[7],
        light_colorblind   = scale.orange[7],
        dark               = scale.orange[3],
        dark_colorblind    = scale.orange[3],
        dark_dimmed        = scale.orange[3],
        dark_high_contrast = scale.orange[3],
    })

    local color_green = themes({
        light              = scale.green[7],
        light_colorblind   = scale.green[7],
        dark               = scale.green[2],
        dark_colorblind    = scale.green[2],
        dark_dimmed        = scale.green[2],
        dark_high_contrast = scale.green[2],
    })

    local color_gray = themes({
        light              = scale.gray[6],
        light_colorblind   = scale.gray[6],
        dark               = scale.gray[4],
        dark_colorblind    = scale.gray[4],
        dark_dimmed        = scale.gray[4],
        dark_high_contrast = scale.gray[4]
    })

    local color_default = theme.fg.default
    local color_success = theme.success.fg
    local color_danger = theme.danger.fg
    local color_warning = theme.attention.fg

    local colors = {
        Boolean                = { fg = color_blue },
        ColorColumn            = { bg = M.from_RGBA_to_Hex(theme.codemirror.activelineBg, bg) },
        Comment                = { fg = color_gray },
        Conditional            = { fg = color_red },
        Constant               = { fg = color_blue },
        CursorLine             = { bg = M.from_RGBA_to_Hex(theme.codemirror.activelineBg, bg) },
        CursorLineNr           = { fg = color_default },
        FloatBorder            = { fg = color_default },
        Function               = { fg = color_purple },
        Include                = { fg = color_red },
        Keyword                = { fg = color_red },
        Label                  = { fg = color_blue },
        LineNr                 = { fg = scale.gray[7] },
        NonText                = { fg = scale.gray[7] },
        Normal                 = { bg = theme.canvas.default, fg = color_default },
        NormalFloat            = { bg = theme.menu.bgActive,  fg = color_default },
        Number                 = { fg = color_blue },
        Operator               = { fg = color_red },
        Pmenu                  = { bg = theme.menu.bgActive, fg = color_default },
        PmenuSel               = { bg = M.from_RGBA_to_Hex(theme.codemirror.selectionBg, bg) },
        Repeat                 = { fg = color_red },
        SignColumn             = { bg = theme.canvas.default },
        Special                = { fg = color_blue },
        Statement              = { fg = color_red },
        String                 = { fg = color_blue_2 },
        Tag                    = { fg = color_green },
        Title                  = { fg = color_blue },
        Type                   = { fg = color_red },
        Visual                 = { bg = M.from_RGBA_to_Hex(theme.codemirror.selectionBg, bg) },

        -------------------------------------------

        TSBoolean                          = { link = "Boolean" },
        TSComment                          = { link = "Comment" },
        TSConditional                      = { link = "Conditional" },
        TSConstant                         = { link = "Constant" },
        TSConstBuiltin                     = { fg = color_blue },
        TSConstructor                      = { fg = color_default },
        TSInclude                          = { link = "Include" },
        TSKeyword                          = { link = "Keyword" },
        TSKeywordFunction                  = { link = "Statement" },
        TSLabel                            = { link = "Label" },
        TSField                            = { fg = color_default },
        TSFuncBuiltin                      = { fg = color_blue },
        TSFuncMacro                        = { fg = color_purple },
        TSFunction                         = { link = "Function" },
        TSMethod                           = { fg = color_blue },
        TSNameSpace                        = { fg = color_blue },
        TSNumber                           = { link = "Number" },
        TSOperator                         = { link = "Operator" },
        TSParameter                        = { fg = color_default },
        TSPunctBracket                     = { fg = color_default },
        TSPunctDelimiter                   = { fg = color_default },
        TSPunctSpecial                     = { link = "Special" },
        TSProperty                         = { fg = color_default },
        TSRepeat                           = { link = "Repeat" },
        TSString                           = { link = "String" },
        TSTag                              = { link = "Tag" },
        TSTagDelimiter                     = { fg = color_default },
        TSTextReference                    = { link = "String" },
        TSType                             = { link = "Type" },
        TSTypeBuiltin                      = { link = "Type" },
        TSURI                              = { link = "String" },
        TSVariable                         = { fg = color_default },
        TSVariableBuiltin                  = { fg = color_blue },

        LspDiagnosticsVirtualTextError     = { fg = color_danger },
        LspDiagnosticsDefaultError         = { fg = color_danger },
        LspDiagnosticsDefaultWarning       = { fg = color_warning },
        LspDiagnosticsDefaultInformation   = { fg = color_warning },
        LspDiagnosticsDefaultHint          = { fg = color_warning },
        LspDiagnosticsUnderlineError       = { fg = color_danger },
        LspDiagnosticsUnderlineWarning     = { fg = color_warning },
        LspDiagnosticsUnderlineInformation = { fg = color_warning },
        LspDiagnosticsVirtualTextHint      = { fg = color_warning },
        DiagnosticError                    = { link = "LspDiagnosticsDefaultError" },
        DiagnosticWarn                     = { link = "LspDiagnosticsDefaultWarning" },
        DiagnosticInfo                     = { link = "LspDiagnosticsDefaultInformation" },
        DiagnosticHint                     = { link = "LspDiagnosticsDefaultHint" },
        DiagnosticUnderlineError           = { link = "LspDiagnosticsUnderlineError" },
        DiagnosticUnderlineWarn            = { link = "LspDiagnosticsUnderlineWarning" },
        DiagnosticUnderlineInfo            = { link = "LspDiagnosticsUnderlineInformation" },
        DiagnosticUnderlineHint            = { link = "LspDiagnosticsVirtualTextHint" },

        GitGutterAdd                       = { fg = color_success },
        GitGutterChange                    = { fg = color_warning },
        GitGutterDelete                    = { fg = color_danger },

        markdownLink                       = { link = "markdownLinkText" },
        markdownListMarker                 = { fg = color_orange },
        markdownLinkText                   = { link = "String" },
        markdownUrl                        = { fg = color_default },
        markdownH1                         = { link = "Special" },
        markdownH1Delimiter                = { link = "Special" },
        markdownH2                         = { link = "Special" },
        markdownH2Delimiter                = { link = "Special" },
        markdownH3                         = { link = "Special" },
        markdownH3Delimiter                = { link = "Special" },
        markdownH4                         = { link = "Special" },
        markdownH4Delimiter                = { link = "Special" },
        markdownH5                         = { link = "Special" },
        markdownH5Delimiter                = { link = "Special" },
        markdownH6                         = { link = "Special" },
        markdownH6Delimiter                = { link = "Special" },

        makeCommands                       = { fg = color_default },
        makeIdent                          = { fg = color_blue },
        makeSpecial                        = { fg = color_red },
        makeSpecTarget                     = { fg = color_blue },
        makeTarget                         = { fg = color_purple },

        dockerfileKeyword                  = { fg = color_red },
        dockerfileShell                    = { fg = color_default },

        shOperator                         = { fg = color_default },
        shOption                           = { fg = color_default },

        gitconfigSection                   = { fg = color_red },
        gitconfigVariable                  = { fg = color_default },

        gomodGoVersion                     = { link = "Number" },
        gomodVersion                       = { link = "Number" },

        NvimTreeGitDirty                   = { fg = color_danger },
        NvimTreeGitStaged                  = { fg = color_success },
        NvimTreeEmptyFolderName            = { fg = color_default },
        NvimTreeFolderIcon                 = { fg = color_default },
        NvimTreeFolderName                 = { fg = color_default },
        NvimTreeOpenedFolderName           = { fg = color_default },
        NvimTreeRootFolder                 = { fg = color_default },
        NvimTreeSymlink                    = { fg = color_default },

        CmpDocumentation                   = { link = "NormalFloat" },
        CmpDocumentationBorder             = { link = "FloatBorder" },

        CompeDocumentation                 = { link = "NormalFloat" },
        CompeDocumentationBorder           = { link = "FloatBorder" },
    }

    return colors
end

local loaded = false

function M.setup(config)
    if loaded then return end

    loaded = true

    local theme = get_theme(config.theme)

    if not theme then
        error('github-theme.nvim: Invalid theme [' .. config.theme .. ']')
        return
    end

    -- vim.api.nvim_command('hi clear')
    if vim.fn.exists('syntax_on') then
        vim.api.nvim_command('syntax reset')
    end

    local github_colors = 'github_' .. config.theme
    vim.g.colors_name   = github_colors
    vim.o.termguicolors = true

    local light_themes = {
        ["light"]               = true,
        ["light_colorblind"]    = true,
        ["light_high_contrast"] = true,
    }

    if light_themes[config.theme] then
        vim.o.background = 'light'
    else
        vim.o.background = 'dark'
    end

    for group, styles in pairs(code_syntax(config.theme, theme)) do
        highlight(group, styles)
    end
end

return M
