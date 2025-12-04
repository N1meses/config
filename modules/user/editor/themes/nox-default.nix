{
  # Nox Default Theme for Helix
  # Ported from VSCode Nox Theme by Agamjot-Singh
  # https://marketplace.visualstudio.com/items?itemName=Agamjot-Singh.nox-theme

  nox-default = {
    # UI Elements
    "ui.background" = { bg = "#0d0d0d"; };
    "ui.text" = { fg = "#d4d4d4"; };
    "ui.text.focus" = { fg = "#ffffff"; };
    "ui.text.info" = { fg = "#cccccc"; };
    "ui.virtual" = { fg = "#404040"; };
    "ui.virtual.indent-guide" = { fg = "#404040"; };
    "ui.virtual.whitespace" = { fg = "#e3e4e229"; };

    "ui.cursor" = { bg = "#aeafad"; fg = "#0d0d0d"; };
    "ui.cursor.primary" = { bg = "#aeafad"; fg = "#0d0d0d"; };
    "ui.cursor.match" = { bg = "#515c6a"; fg = "#ffffff"; };

    "ui.selection" = { bg = "#264f78"; };
    "ui.selection.primary" = { bg = "#264f78"; };
    "ui.highlight" = { bg = "#2a2d2e"; };

    "ui.linenr" = { fg = "#858585"; };
    "ui.linenr.selected" = { fg = "#c6c6c6"; };

    "ui.statusline" = { fg = "#ffffff"; bg = "#040404"; };
    "ui.statusline.inactive" = { fg = "#cccccc99"; bg = "#3c3c3c99"; };
    "ui.statusline.normal" = { fg = "#ffffff"; bg = "#040404"; };
    "ui.statusline.insert" = { fg = "#ffffff"; bg = "#0e4d77"; };
    "ui.statusline.select" = { fg = "#ffffff"; bg = "#16825d"; };

    "ui.popup" = { fg = "#cccccc"; bg = "#1b1b1b"; };
    "ui.popup.info" = { fg = "#d4d4d4"; bg = "#1b1b1b"; };
    "ui.window" = { fg = "#5F5F5F"; };
    "ui.help" = { fg = "#cccccc"; bg = "#1b1b1b"; };

    "ui.menu" = { fg = "#cccccc"; bg = "#1b1b1b"; };
    "ui.menu.selected" = { fg = "#ffffff"; bg = "#062e49"; };
    "ui.menu.scroll" = { fg = "#79797966"; bg = "#1b1b1b"; };

    # Diagnostic
    "error" = { fg = "#f48771"; };
    "warning" = { fg = "#cca700"; };
    "info" = { fg = "#75beff"; };
    "hint" = { fg = "#999999"; };

    "diagnostic.error" = { underline = { style = "curl"; color = "#f48771"; }; };
    "diagnostic.warning" = { underline = { style = "curl"; color = "#cca700"; }; };
    "diagnostic.info" = { underline = { style = "curl"; color = "#75beff"; }; };
    "diagnostic.hint" = { underline = { style = "curl"; color = "#999999"; }; };

    # Syntax Highlighting
    "comment" = { fg = "#57A64A"; };
    "comment.block" = { fg = "#57A64A"; };
    "comment.line" = { fg = "#57A64A"; };
    "comment.block.documentation" = { fg = "#6A9955"; };

    "constant" = { fg = "#569cd6"; };
    "constant.builtin" = { fg = "#569cd6"; };
    "constant.character" = { fg = "#D69D85"; };
    "constant.character.escape" = { fg = "#d16969"; };
    "constant.numeric" = { fg = "#b5cea8"; };

    "string" = { fg = "#D69D85"; };
    "string.regexp" = { fg = "#d16969"; };
    "string.special" = { fg = "#569cd6"; };

    "keyword" = { fg = "#569cd6"; };
    "keyword.control" = { fg = "#569cd6"; };
    "keyword.control.import" = { fg = "#569cd6"; };
    "keyword.directive" = { fg = "#9B9B9B"; };
    "keyword.function" = { fg = "#569cd6"; };
    "keyword.operator" = { fg = "#B4B4B4"; };
    "keyword.storage" = { fg = "#569cd6"; };
    "keyword.storage.type" = { fg = "#569cd6"; };
    "keyword.storage.modifier" = { fg = "#569cd6"; };

    "operator" = { fg = "#B4B4B4"; };

    "function" = { fg = "#C8C8C8"; };
    "function.builtin" = { fg = "#C8C8C8"; };
    "function.macro" = { fg = "#BD63C5"; };
    "function.method" = { fg = "#C8C8C8"; };

    "variable" = { fg = "#C8C8C8"; };
    "variable.builtin" = { fg = "#569cd6"; };
    "variable.parameter" = { fg = "#7F7F7F"; };
    "variable.other.member" = { fg = "#DADADA"; };

    "type" = { fg = "#4EC9B0"; };
    "type.builtin" = { fg = "#4EC9B0"; };
    "type.enum.variant" = { fg = "#B8D7A3"; };

    "constructor" = { fg = "#4EC9B0"; };

    "label" = { fg = "#C8C8C8"; };
    "namespace" = { fg = "#C8C8C8"; };

    "attribute" = { fg = "#9cdcfe"; };
    "property" = { fg = "#9cdcfe"; };

    "tag" = { fg = "#569cd6"; };
    "special" = { fg = "#BD63C5"; };

    # Markup (Markdown, etc.)
    "markup.heading" = { fg = "#569cd6"; modifiers = ["bold"]; };
    "markup.bold" = { fg = "#569cd6"; modifiers = ["bold"]; };
    "markup.italic" = { modifiers = ["italic"]; };
    "markup.link.url" = { fg = "#3890d1"; underline = { style = "line"; }; };
    "markup.link.text" = { fg = "#9cdcfe"; };
    "markup.quote" = { fg = "#6A9955"; };
    "markup.raw" = { fg = "#D69D85"; };
    "markup.list" = { fg = "#6796e6"; };

    # Diff
    "diff.plus" = { fg = "#81b88b"; };
    "diff.minus" = { fg = "#c74e39"; };
    "diff.delta" = { fg = "#e2c08d"; };
  };
}
