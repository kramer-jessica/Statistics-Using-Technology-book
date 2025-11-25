-- class-to-macro.lua
-- Maps inline span classes (var, def, dpd, typein, etc.) to LaTeX macros for PDF,
-- and adds a cross-format reference label macro using the class ".ref-label" 
-- that works in both HTML and PDF.

-- Lua 5.3+ unpack
local unpack = table.unpack

-- Detect PDF/LaTeX output
local function is_pdf()
  return (FORMAT or ""):match("latex") or (FORMAT or ""):match("pdf")
end

-- Utility: does a block/span have a given class?
local function has_class(el, name)
  for _, cls in ipairs(el.classes or {}) do
    if cls == name then return true end
  end
  return false
end

-- Escape TeX special chars for macro arguments
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

-- Map inline classes to LaTeX macros (PDF only).
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
  typein = "Typein",
  button = "Button"
}

-- Inline spans: convert known classes to LaTeX macros in PDF;
-- also support inline .ref-label anchors.
function Span(el)
  -- Reference label macro: [anything]{#id .ref-label}
  if has_class(el, "ref-label") and el.identifier ~= "" then
    local id = el.identifier
    if is_pdf() then
      return pandoc.RawInline("tex", "\\hypertarget{" .. id .. "}{}")
    else
      return pandoc.RawInline("html", '<a id="' .. id .. '"></a>')
    end
  end

  if not is_pdf() then
    return el
  end

  for _, cls in ipairs(el.classes or {}) do
    local macro = inline_map[cls]
    if macro then
      local txt = pandoc.utils.stringify(el.content)
      return pandoc.RawInline("tex", "\\" .. macro .. "{" .. tex_escape(txt) .. "}")
    end
  end

  return el
end

-- Block-level transforms:
-- 1) Step boxes (if you still use .step -> a LaTeX environment)
-- 2) Reference label macro: ::: {#id .ref-label} :::
function Div(el)
  -- Block reference label
  if has_class(el, "ref-label") and el.identifier ~= "" then
    local id = el.identifier
    if is_pdf() then
      return pandoc.RawBlock("latex", "\\hypertarget{" .. id .. "}{}")
    else
      return pandoc.RawBlock("html", '<a id="' .. id .. '"></a>')
    end
  end

  -- Optional: if you have a .step class mapped to a LaTeX box in PDF
  if has_class(el, "step") then
    if is_pdf() then
      return {
        pandoc.RawBlock("latex", "\\begin{stepbox}"),
        unpack(el.content),
        pandoc.RawBlock("latex", "\\end{stepbox}")
      }
    else
      return el
    end
  end

  return el
end