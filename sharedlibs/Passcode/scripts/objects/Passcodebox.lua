---@class Passcodebox : Object
---@overload fun(...) : Passcodebox
local Passcodebox, super = Class(Object)

function Passcodebox:init(x, y, width, height, options)
    super.init(self, x, y, width, height)

    self.box = UIBox(0, 0, width, height)
    self.box.layer = -1
    self:addChild(self.box)

    self.rows = {}
    self.selected_characters = {}
    self.correct = {}

    options = options or {}
    self.current_row = options["default_row"] or 1
    self:setColors(options["color"], options["highlight"], options["correct_color"], options["incorrect_color"])

    self.correct_func = options["correct_func"]
    self.check_correct = (options["check_correct"] == nil) and true or options["check_correct"]
    self.spacing = options["spacing"] or 16

    self.confirmed = false
    self.done = false

    self.font = Assets.getFont("main")
    self.arrow = Assets.getTexture("ui/flat_arrow_up")

    self.up_delay = 0
    self.down_delay = 0

    self.up_flash = 0
    self.down_flash = 0

    self.timer_1 = 0
    self.timer_2 = 0

    self.confirm_wait = false
    self.updated = false
end

function Passcodebox:update()
    super.update(self)
    if not self.confirmed and self.updated then
        self.up_delay = self.up_delay - DTMULT
        self.down_delay = self.down_delay - DTMULT

        self.up_flash = self.up_flash - DTMULT
        self.down_flash = self.down_flash - DTMULT

        local old_row = self.current_row
        if Input.pressed("left")  then
            local do_while = true
            local call_amount = 0
            while do_while do
                self.current_row = (self.current_row - 2) % #self.rows + 1
                do_while = self:getCurrentRow().locked == true
                call_amount = call_amount + 1
                if call_amount > #self.rows then
                    error("All passcode options are locked.") -- Prevents freezing and returns an error instead
                end
            end
        end
        if Input.pressed("right") then
            local do_while = true
            local call_amount = 0
            while do_while do
                self.current_row = self.current_row % #self.rows + 1
                do_while = self:getCurrentRow().locked == true
                call_amount = call_amount + 1
                if call_amount > #self.rows then
                    error("All passcode options are locked.") -- Prevents freezing and returns an error instead
                end
            end
        end
        self.current_row = (self.current_row - 1) % #self.rows + 1
        if self.current_row ~= old_row then
            Assets.playSound("ui_move")
            self.up_delay = 0
            self.down_delay = 0
        end

        if not self:getCurrentRow().locked then
            local selected_char = self:getCurrentSelected()
            if Input.down("up") then
                self.up_flash = 3
                if self.up_delay <= 0 and not Input.down("down") then
                    self.selected_characters[self.current_row] = (self:getCurrentSelected() + 1)
                    self.up_delay = 5
                end
            end
            if Input.down("down") then
                self.down_flash = 3
                if self.down_delay <= 0 and not Input.down("up") then
                    self.selected_characters[self.current_row] = (self:getCurrentSelected() - 1)
                    self.down_delay = 5
                end
            end
            self.selected_characters[self.current_row] = (self:getCurrentSelected() - 1) % #self:getCurrentRow() + 1
            if selected_char ~= self:getCurrentSelected() then
                Assets.playSound("ui_move", 1, Input.down("up") and 1 or 0.9)
            end
        end
    else
        if not self.confirm_wait then
            self.timer_1 = self.timer_1 + DTMULT
            if self.timer_1 >= 30 then
                if not self:checkCorrect() then
                    Assets.playSound("error")
                else
                    Assets.playSound("bell")
                end
                self.confirm_wait = true
            end
        elseif not self.done then
            self.timer_2 = self.timer_2 + DTMULT
            if self.timer_2 >= 30 then
                self.done = true
            end
        end
    end

    if Input.pressed("confirm") and self.updated and not self.confirmed then
        Assets.playSound("ui_move", 1, 1.2)
        if self.check_correct then
            self.confirmed = true
        else
            self.done = true
        end
    end
    self.updated = true
end

function Passcodebox:draw()
    super.draw(self)
    love.graphics.setFont(self.font)

    local total_width = 0
    local row_widths = {}
    for i, row in ipairs(self.rows) do
        local largest_width = 0
        for _, character in ipairs(row) do
            largest_width = math.max(largest_width, self.font:getWidth(character))
        end
        table.insert(row_widths, largest_width)
        total_width = total_width + largest_width
        if i ~= #self.rows then total_width = total_width + self.spacing end
    end

    local draw_x = (self.width - total_width) / 2
    local draw_y = (self.height - self.font:getHeight()) / 2
    for i, row in ipairs(self.rows) do
        if self.current_row == i and not self.confirmed and not self:getCurrentRow().locked then
            local arrow_width, arrow_height = self.arrow:getWidth() * 2, self.arrow:getHeight() * 2
            local arrow_draw_x = math.floor(draw_x + (row_widths[i] - arrow_width) / 2)
            Draw.setColor((self.up_flash >= 0) and COLORS.white or COLORS.gray)
            Draw.draw(self.arrow, arrow_draw_x, draw_y - arrow_height - 2, 0, 2, 2)

            Draw.setColor((self.down_flash >= 0) and COLORS.white or COLORS.gray)
            Draw.draw(self.arrow, arrow_draw_x, draw_y + self.font:getHeight() + arrow_height + 2, 0, 2, -2)
            Draw.setColor(self.hover_color)
        elseif not self.confirm_wait then
            Draw.setColor(self.main_color)
        else
            if self:checkCorrect() then
                Draw.setColor(self.correct_color)
            else
                Draw.setColor(self.incorrect_color)
            end
        end

        love.graphics.print(row[self.selected_characters[i]], draw_x, draw_y)
        draw_x = draw_x + row_widths[i] + self.spacing
    end
end

function Passcodebox:getCurrentSelected()
    return self.selected_characters[self.current_row]
end

function Passcodebox:getCurrentRow()
    return self.rows[self.current_row]
end

function Passcodebox:setSize(w, h)
    self.width, self.height = w or 0, h or 0

    self.text:setSize(self.width, self.height)
    self.box:setSize(self.width, self.height)
end

function Passcodebox:clearCharacters()
    self.rows = {}
    self.current_row = 0
end

--- Adds a new character to the Passcodebox.
---@param row table The name of the new character that will be shown for the selection.
function Passcodebox:addRow(row)
    local row_char
    if row.preset == "numbers" then row_char = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"} end
    if row.preset == "alphabet" then row_char = ALPHABET end
    if row.preset == "alphabet_upper" then
        row_char = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U",
        "V", "W", "X", "Y", "Z" }
    end
    if row_char then
        Utils.merge(row, row_char)
    end
    table.insert(self.rows, row)
    table.insert(self.selected_characters, 1)
end

function Passcodebox:checkCorrect()
    if self.correct_func and type(self.correct_func) == "function" then
        return self.correct_func(self:getSelectedCharacters())
    end
    local correct = true
    for i, row in ipairs(self.rows) do
        local selected_character = row[self.selected_characters[i]]
        if selected_character ~= row.c then
            correct = false
            break
        end
    end
    return correct
end

function Passcodebox:getSelectedCharacters()
    local selected_characters = {}
    for i, row in ipairs(self.rows) do
        table.insert(selected_characters, row[self.selected_characters[i]])
    end
    return selected_characters
end

--- Sets the main and hover colors for every character in the Passcodebox.
---@param main? table   The main color to set for all characters, or a table of main colors for each individual character. (Defaults to `COLORS.white`)
---@param hover? table  The hover color to set for all characters, or a table of hover colors for each individual character. (Defaults to `COLORS.yellow`)
function Passcodebox:setColors(main, hover, correct, incorrect)
    self.main_color = main or COLORS.white
    self.hover_color = hover or COLORS.white
    self.correct_color = correct or COLORS.yellow
    self.incorrect_color = incorrect or COLORS.red
end

function Passcodebox:getBorder()
    if self.box.visible then
        return self.box:getBorder()
    else
        return 0, 0
    end
end

return Passcodebox