-- filters/class-to-macro.lua
-- Purpose:
--   1) Map inline span classes to LaTeX macros for PDF.
--   2) Turn ::: step blocks into a tcolorbox (PDF) or leave as <div class="step"> (HTML).
-- Notes:
--   Collapsibles are now handled with Quarto callouts (no Lua required).

-- ----- Inline classes -> LaTeX macro names (defined in _preamble.tex) -----
local inline_map = {
  var    = "Var",
  def    = "Def",
  des    = "Des",
  data   = "Data",
  dpd    = "Dpd",
  fun    = "Fun",
  dialog = "Dialog",
  repo   = "Repo",
  ans    = "Ans",
  typein = "Typein",     -- maps [.typein] -> \Typein{...} in PDF
  button = "Button"      -- maps [.button] -> \Button{...} in PDF
}

local function is_pdf()
  return FORMAT:match("latex") or FORMAT:match("pdf")
end

-- Minimal TeX escape for macro arguments
local function tex_escape(s)
  local r = tostring(s)
  r = r:gsub("\\", "\\textbackslash{}")
  r = r:gsub("%%", "\\%%")
  r = r:gsub("{", "\\{")
  r = r:gsub("}", "\\}")
  r = r:gsub("%$", "\\$")
  r = r:gsub("#", "\\#")
  r = r:gsub("&", "\\&")
  r = r:gsub("_", "\\_")
  r = r:gsub("%^", "\\^{}")
  r = r:gsub("~", "\\textasciitilde{}")
  return r
end

local unpack = table.unpack or unpack

-- Inline span classes -> LaTeX macros in PDF; no change in HTML
function Span(el)
  if not is_pdf() then return el end
  for _, cls in ipairs(el.classes) do
    local macro = inline_map[cls]
    if macro then
      local txt = pandoc.utils.stringify(el.content)
      return pandoc.RawInline("tex", "\\" .. macro .. "{" .. tex_escape(txt) .. "}")
    end
  end
  return el
end

-- Step box block: ::: step ... :::
function Div(el)
  for _, cls in ipairs(el.classes) do
    if cls == "step" then
      if is_pdf() then
        return {
          pandoc.RawBlock("latex", "\\begin{stepbox}"),
          unpack(el.content),
          pandoc.RawBlock("latex", "\\end{stepbox}")
        }
      else
        -- HTML: keep <div class="step">...</div> for CSS styling
        return el
      end
    end
  end
  return el
end