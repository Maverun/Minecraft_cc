local M = {}

M.line = 1

function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end



function M.round(x) -- I am lazy okay?
    return math.floor(x+0.5)
end


function M.write(x,y,text,fg,bg, clear_line)
    mon.setCursorPos(x,y)
    if clear_line then
        mon.clearLine()
    end
    if fg then
        mon.setTextColor(fg)
    end
    if bg then
        mon.setBackgroundColor(bg)
    end
    mon.write(text)

    -- reset
    mon.setTextColor(colors.white)
    mon.setBackgroundColor(colors.black)
end

function M.writeLine(text, fg, bg)
    M.write(1,M.line, text, fg,bg, true)
    M.line = M.line + 1
end

function M.setLine(n)
    M.line = n
end

function M.resetLine()
    M.line = 0
end

function M.resetLineBody(y, range)
    for i = y, (range + y) do
        mon.setCursorPos(0,i)
        mon.clearLine()
    end
end


function M.drawHorizontalLine(x, y, length, color)
    local oldBgColor = mon.getBackgroundColor() -- Get the current background color
    mon.setBackgroundColor(color)               -- Set the background color to the color
    for i = x, (length + x) do                      -- Start a loop starting at x and ending when x gets to x + length
        mon.setCursorPos(i, y)                  -- Set the cursor position to i, y
        mon.write(" ")                          -- Write that color to the screen
    end
    mon.setBackgroundColor(oldBgColor)          -- Reset the background color
end

function M.drawVerticalLine(x, y, length, color)
    local oldBgColor = mon.getBackgroundColor() -- Get the current background color
    mon.setBackgroundColor(color)               -- Set the background color to the color
    for i = y, (length + y) do                      -- Start a loop starting at y and ending when y gets to y + length
        mon.setCursorPos(x, i)                  -- Set the cursor position to x, i
        mon.write(" ")                          -- Write that color to the screen
    end
    mon.setBackgroundColor(oldBgColor)          -- Reset the background color
end

function M.color_percent(n)
    if n > 90 then
        color = colors.green
    elseif n > 50 then
        color = colors.yellow
    else
        color = colors.red
    end
    return color
end

function M.reverse_color_percent(n)
    if n > 80 then
        color = colors.red
    elseif n > 50 then
        color = colors.yellow
    else
        color = colors.green
    end
    return color

end

function M.get_percent(available, capacity)
    return M.round((available/capacity)*100)
end

function M.status_format(x,y,limit,ltext,lcolor, rtext, rcolor, is_selected)
    if is_selected then
        bg = colors.purple
    else
        bg = colors.black
    end
    temp = limit - string.len(rtext)
    blank = temp - string.len(ltext)
    M.write(x,y, ltext .. string.rep(" ", blank), lcolor, bg)
    M.write(x+temp, y, rtext, rcolor,bg)
    -- M.write(string.len(ltext) + 1, y, string.rep(" ", blank - 1), nil, bg)
    final_pos = x + limit
    M.drawVerticalLine(final_pos, 1, 1, colors.white)
    -- print("status_format is ", x, string.len(ltext) + 1, blank, final_pos, is_selected)
    return final_pos + 1
end

function M.format_number(n)
    local formatted = tostring(n)
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function M.format_percent(available, capacity)
    return utility.get_percent(available, capacity).."%"

end

function M.format_slot(available, capacity)
    return available .."/"..capacity
end

return M
