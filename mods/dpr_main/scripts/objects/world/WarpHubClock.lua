local WarpHubClock, super = Class(Object)

function WarpHubClock:init(x, y)
    super.init(self, x, y)
	self.font = Assets.getFont("main")
	self.clock_colors = {
		ColorUtils.hexToRGB("#60e0a8ff"),
		ColorUtils.hexToRGB("#589040ff"),
	}
	self.clock_color = self.clock_colors[1]
	self.clock_color_timer = 0
end

function WarpHubClock:convertToGameTime(real_seconds, sec_per_hour)
    local sec_per_minute = sec_per_hour / 60  -- Calculate how many real seconds per in-game minute

    local in_game_hours = real_seconds / sec_per_hour
    local in_game_days = math.floor(in_game_hours / 24)
    local remaining_hours = math.floor(in_game_hours % 24)

    -- Calculate remaining real-world seconds after extracting full hours
    local remaining_seconds = real_seconds % sec_per_hour
    local in_game_minutes = math.floor(remaining_seconds / sec_per_minute)

    return in_game_days, remaining_hours, in_game_minutes
end

function WarpHubClock:draw()
    super.draw(self)
    Draw.setColor(1, 1, 1, 1)

    local time = Game.playtime

    time = math.floor(time)

    local days, hours, minutes = self:convertToGameTime(time, 60)

    local MM = "AM"

    if hours >= 12 then 
        MM = "PM"
    end

    local jim = ""
    if minutes < 10 then 
        jim = "0"
    end

    if hours > 12 then 
        hours = hours - 12
    elseif hours == 0 then
        hours = 12
    end
    local weed = days%7
    local day = { [0] = "SUNDAY", "MONDAY", "TUESDAY", "THURSDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"}
    weed = day[weed] or weed

	self.clock_color_timer = self.clock_color_timer + DTMULT
	self.clock_color = ColorUtils.mergeColor(self.clock_colors[1], self.clock_colors[2], 0.5 + (math.sin(self.clock_color_timer / 60) * 0.5))

	love.graphics.setFont(self.font)
	Draw.setColor(self.clock_color)
    love.graphics.print(string.format(weed.. "\n%d : " ..jim.. "%d " ..MM, hours, minutes), 0, 0)
end

return WarpHubClock