-- Map span classes to LaTeX macros for PDF output; leave HTML alone.
local map = {
  var="Var", def="Def", des="Des", data="Data", dpd="Dpd",
  fun="Fun", dialog="Dialog", repo="Repo", ans="Ans"
}

function Span(el)
  if FORMAT:match("latex") then
    for _, cls in ipairs(el.classes) do
      local m = map[cls]
      if m then
        local txt = pandoc.utils.stringify(el.content)
        return pandoc.RawInline("tex", "\\" .. m .. "{" .. txt .. "}")
      end
    end
  end
  return el
end