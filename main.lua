---
--- Created by Maverun - https://github.com/maverun
--- Initial date created: 8/20/2025
---
--- Require addon:
--- https://www.curseforge.com/minecraft/mc-mods/flux-network-x-cc-tweaked
--  https://www.curseforge.com/minecraft/mc-mods/advanced-peripherals


utility = require("utility")
print(utility)

mon = peripheral.find("monitor")                       --Monitor
me = peripheral.find("me_bridge")                      --MeBridge
flux = peripheral.find("fluxnetworks:flux_controller") -- Find a flux controller

mon.setTextScale(0.5)

monx, mony = mon.getSize()
print("Monitor size is " .. monx .. ","..mony)

-- changeable from prev ME status online
prev_status = false

ae2_current_select = {groups = {}}

function flux_information()
    stats = flux.networkStats()
    utility.setLine(3)
    utility.writeLine(utility.format_number(flux.getEnergy()) ..
    " / " .. utility.format_number(flux.getEnergyCapacity()) .. " FE")
    utility.writeLine("Controllers: " .. stats.controllerCount)
    utility.writeLine("Points: " .. stats.pointCount)
    utility.writeLine("Storages: " .. stats.storageCount)
    utility.writeLine("Buffer: " .. stats.totalBuffer)
    utility.writeLine("Total Energy: " .. stats.totalEnergy)
    utility.writeLine("Energy Input: " .. stats.energyInput)
    utility.writeLine("Energy Output: " .. stats.energyOutput)
    utility.writeLine("Average Tick: " .. stats.averageTick)
    utility.writeLine("Connection Count: " .. stats.connectionCount)
end

function cpu_information()
    utility.resetLineBody(3, 30)
    currentCPUSlot = me.getCraftingCPUs()
    utility.setLine(3)
    table.sort(currentCPUSlot, function(a,b) return a.name < b.name end)
    for k, v in ipairs(currentCPUSlot) do
        fmt = k .. "." .. v.name .. ":"
        color = colors.white
        if v.isBusy then
            res = v.craftingJob.resource
            fmt = fmt .. res.displayName .. ": " .. res.count
            color = colors.red
        end
        utility.writeLine(fmt, color)
    end
end

function cpu_busy_status()
    isBusyCPU = 0
    currentCPUSlot = me.getCraftingCPUs()
    for k, v in ipairs(currentCPUSlot) do
        if v.isBusy == true then
            isBusyCPU = isBusyCPU + 1
        end
    end
    return isBusyCPU
end

function cpu_total_status()
    return #me.getCraftingCPUs()
end

function mouse_click()
    ae2_last_click = 0
    while true do
        local _, monitor_touched, x, y = os.pullEvent("monitor_touch")
        -- utility.write(1, 39, "got touched at " .. x .. ":" .. y, colors.blue)
        -- utility.write(25, 3, "got touched at " .. x .. ":" .. y, colors.blue)
        print("TRIGGER MONITOR TOUCH!")
        print("got touched at "..x..","..y)
        print(y)
        if y <= 1 then
            which_mode = math.floor(x / 10) + 1
            print(which_mode)
            utility.write(1, 20, which_mode, colors.blue)
            current_mode.is_selected = false
            current_mode = status_mode[which_mode]
            current_mode.is_selected = true
            utility.resetLineBody(3, 30)
        elseif y-2 > 0 then
            select_y = y - 2  -- 2 cuz it is after status line
            if ae2_current_select.groups and select_y >= ae2_last_click then
                select_y = select_y -  #ae2_current_select.groups
            end
            if current_mode.mode == "AE2" then
                max_x = get_max_length()
                if x < max_x then
                    print("the select is", select_y)
                    print("under ae2 crafting recipe")
                    requestor =  require("requester")
                    get_name = requestor[select_y]
                    print(get_name)
                    -- utility.write(25,40, "you have select ".. current_mode.mode .. " and ".. get_name.name, colors.green)
                    if get_name.name == ae2_current_select.name then --unselect it
                        ae2_current_select = {groups = {}}
                    elseif get_name.groups then
                        ae2_current_select = get_name
                        ae2_last_click = select_y
                    end
                end
            end
        end
        sleep(0.5)
    end
end

function status_update()
    utility.drawHorizontalLine(1, 2, monx , colors.white)
    current_x = 1
    -- print("under status_update")
    for i, mode in ipairs(status_mode) do
        -- print(mode.mode)
        available = mode.available()
        capacity = mode.capacity()
        fmt_num = mode.num_method(available, capacity)
        fmt_num_color = mode.num_color(utility.get_percent(available, capacity))
        current_x = utility.status_format(current_x, 1, 9, mode.mode, mode.text_color, fmt_num, fmt_num_color,
            mode.is_selected)
    end
end

function me_item(tb, do_craft)
    item = me.getItem({name = tb.id})
    crafting = 0 -- 0 = no need, 1 = is crafting right now, 2 = Unable to do so, 3 = Not found
    -- let check if it have meet requirement, if not, then we will check if it craftable, if yes then craft it
    if item == nil then
        return 4, nil
    elseif me.isCrafting(item) then
        return 1, item -- already crafting right now
    end
    if item and item.count <= tb.threshold then
        if item.isCraftable and do_craft then
            remain = tb.require - item.count
            me.craftItem({name = tb.id, count = remain})
            print("Crafting ".. tb.name .. " for ".. remain)
            crafting = 1
        else
            crafting = 2
        end
    elseif item and item.count >= tb.require then
        crafting = 0
    elseif item and item.count < tb.threshold then
        crafting = 1
    end
    return crafting, item
end


function crafting_level_color(crafting_level)
    if crafting_level == 3 then
        return colors.orange
    elseif crafting_level == 2 then
        return colors.red
    elseif crafting_level == 1 then
        return colors.yellow
    elseif crafting_level == 4 then
        return colors.lightGray
    else
        return colors.green
    end
end

function get_max_length()
    data = require("requester")
    max_length = 0
    for index, tb in ipairs(data) do
        if tb.groups then
            for _, sub in ipairs(tb.groups) do
                max_length = math.max(max_length, string.len(sub.name))
            end
        else
            max_length = math.max(max_length, string.len(tb.name))
        end
    end
    return max_length
end

function ae2_request_information()
    data = require("requester")
    max_length = get_max_length() + 2
    local prep_mon = {}
    for index, tb in ipairs(data) do
        sub_prep = {}
        crafting_level = 0
        total = 0
        remain = 0
        if tb.groups then -- this is a groups (sub of the main list)
            for j, sub_tb in ipairs(tb.groups) do
                cft_level, item = me_item(sub_tb, true)
                sub_remain = item.count
                crafting_level = math.max(crafting_level, cft_level)
                remain = remain + sub_remain
                total = sub_tb.require
                if tb.name == ae2_current_select.name then
                    -- txt = string.char(0x1A) .. sub_tb.name .. " .... " .. utility.format_percent(sub_remain,sub_tb.require)
                    txt = string.char(0x1A) .. sub_tb.name
                    txt_result = utility.format_slot(sub_remain,sub_tb.require)
                    txt = string.format("%-"..max_length .. "s" .. "%4s", txt, txt_result)
                    color = crafting_level_color(cft_level)
                    table.insert(sub_prep,{text = txt, color = color})
                end
            end
        else
            crafting_level, item = me_item(tb, true)
            remain = item.count
            total = tb.require
        end -- end if statement
        color = crafting_level_color(crafting_level)
        -- txt = index .. ": ".. tb.name .. " .... " .. utility.format_percent(remain,total)
        txt = index .. ": ".. tb.name
        if tb.groups then
            txt_result = utility.format_percent(remain,total)
        else
            txt_result = utility.format_slot(remain,total)
        end
        txt = string.format("%-"..max_length .. "s" .. "%4s", txt, txt_result)
        table.insert(prep_mon,{text = txt, color = color})
        if tb.name == ae2_current_select.name then
            for _, row in ipairs(sub_prep) do
                table.insert(prep_mon, row)
            end
        end
    end -- end of loops

    utility.resetLineBody(3, 30)
    utility.setLine(3)
    for index, tb in ipairs(prep_mon) do
        utility.writeLine(tb.text, tb.color)
    end
end

function ae2_autocraft()
    data = require("requester")
    for _, tb in ipairs(data) do
        if tb.group then --sub group
            for j, sub_tb in ipairs(tb.groups) do
                me_item(sub_tb, true)
            end
        else
            me_item(tb, true)
        end
    end
end

function ae2_start_autocraft()
    max_count = 10
    counter = 9
    while true do
        counter = counter + 1
        if counter >= max_count then
            -- ae2_autocraft()
            counter = 0
        end
        sleep(1)
    end
end


function top_bar()
    while true do
        status_update()
        sleep(1)
    end
end

function main_display()
    while true do
        -- status_update()
        current_mode.selected_mode()
        -- print("after all selection run")
        sleep(1)
    end
end

status_mode = {
    { mode = "FE",  text_color = colors.green,     num_method = utility.format_percent, num_color = utility.color_percent,         available = flux.getEnergy,     capacity = flux.getEnergyCapacity, selected_mode = flux_information, is_selected = false },
    { mode = "AE2", text_color = colors.lightBlue, num_method = utility.format_percent, num_color = utility.color_percent,         available = me.getStoredEnergy, capacity = me.getEnergyCapacity,   selected_mode = ae2_request_information, is_selected = true },
    { mode = "CPU", text_color = colors.blue,      num_method = utility.format_slot,    num_color = utility.reverse_color_percent, available = cpu_busy_status,    capacity = cpu_total_status,       selected_mode = cpu_information,  is_selected = false },
}


current_mode = status_mode[2]
while true do
    -- first we will check if it online or not. If it offline, give big text to monitor!
    isOnline = me.isOnline()
    if isOnline then
        if prev_status == false then
            print("It is online!")
            mon.clear()
        end
        prev_status = isOnline
        parallel.waitForAny(ae2_start_autocraft, main_display, top_bar, mouse_click)
        print("online?")
        -- status_update()

        --It is online!
    else
        if prev_status == true then
            print("It is offline!")
            mon.clear()
        end
        prev_status = isOnline
        --It is not online!
        msg = "OFFLINE"
        targetx = math.floor(monx / 2) - 4
        targety = math.floor(mony / 2)
        mon.setCursorPos(targetx, targety)
        mon.setTextColor(colors.red)
        mon.write(msg)
    end
    sleep(1)
    -- return
end
