-- filters/class-to-macro.lua
--
-- Purpose:
--   Map inline span classes used in Quarto to LaTeX macros
--   for PDF output, while leaving HTML alone.
--
--   Classes handled:
--     .var, .def, .des, .data, .dpd, .fun, .dialog, .repo,
--     .ans, .typein, .button
--
--   HTML:
--     spans are left as-is and styled via CSS.
--
--   PDF/LaTeX:
--     each span is converted to a macro like \Var{...}, \Def{...}, etc.
--
--   Note:
--     We do NOT touch code blocks and we do NOT handle .rg-iframe here.
--     The iframe embedding is done directly via raw HTML in the .qmd.

local utils = pandoc.utils

-- Map span class -> LaTeX macro name
local span_class_to_macro = {
  var    = "Var",
  def    = "Def",
  des    = "Des",
  data   = "Data",
  dpd    = "Dpd",
  fun    = "Fun",
  dialog = "Dialog",
  repo   = "Repo",
  ans    = "Ans",
  typein = "TypeIn",
  button = "Button",
}

-- Handle spans with our special classes
local function handle_styled_span(el)
  -- Only transform for LaTeX/PDF; HTML keeps spans as spans
  if not FORMAT:match("latex") then
    return nil
  end

  for class, macro in pairs(span_class_to_macro) do
    if el.classes:includes(class) then
      local txt = utils.stringify(el.content or el)
      local tex = "\\" .. macro .. "{" .. txt .. "}"
      return pandoc.RawInline("tex", tex)
    end
  end

  return nil
end

-- Main Span handler
function Span(el)
  local replaced = handle_styled_span(el)
  if replaced then
    return replaced
  end

  return el
end