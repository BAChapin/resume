local function is_technologies_paragraph(block)
  if block.t ~= "Para" or #block.content == 0 then
    return false
  end

  local first = block.content[1]
  return first.t == "Strong" and pandoc.utils.stringify(first) == "Technologies:"
end

function Para(block)
  if not is_technologies_paragraph(block) then
    return nil
  end

  if FORMAT:match("latex") then
    return {
      pandoc.RawBlock("latex", "\\vspace{0.35em}"),
      block
    }
  end

  if FORMAT:match("docx") then
    return pandoc.Div(
      { block },
      pandoc.Attr("", {}, { ["custom-style"] = "Technologies" })
    )
  end

  return nil
end
