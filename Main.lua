local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- =============== GAME SCRIPTS DATABASE ===============
local PlaceId = tostring(game.PlaceId)


local ScriptGroups = {
	{ -- Wizard Alchemy
		Ids = {
			"118821269826806",
			"123914747443517"
		},
		Url = "https://raw.githubusercontent.com/leleo2083-eng/Eternal-Scripts/refs/heads/main/Wizard%20Alchemy.eternalxs.lua"
	},

	{ -- Sailor Piece
		Ids = {
			"77747658251236",
			"130167267952199"
		},
		Url = "https://raw.githubusercontent.com/leleo2083-eng/Eternal-Scripts/refs/heads/main/Sailor%20Piece.eternalxs.lua"
	}
}

-- Find matching script URL
local TargetURL = nil

for _, group in pairs(ScriptGroups) do
	for _, id in pairs(group.Ids) do
		if id == PlaceId then
			TargetURL = group.Url
			break
		end
	end
	
	if TargetURL then
		break
	end
end

if not TargetURL then
	warn("[ETERNAL] No script available for Game ID: " .. PlaceId)
	return
end

-- =============== SAFE HTTP GET WITH RETRY ===============
local function SafeHttpGet(url, retries)
	retries = retries or 3
	local lastErr = "Unknown error"

	for attempt = 1, retries do
		local ok, result = pcall(function()
			return game:HttpGet(url, true)
		end)

		if ok and result and #result > 0 then
			return true, result
		else
			lastErr = tostring(result)
			warn("[ETERNAL] HTTP attempt " .. attempt .. " failed: " .. lastErr)

			if attempt < retries then
				task.wait(0.8)
			end
		end
	end

	return false, lastErr
end

-- =============== SAFE EXECUTE WITH RETRY ===============
local function SafeExecute(code, retries)
	retries = retries or 2
	local lastErr = "Unknown error"

	for attempt = 1, retries do
		if attempt > 1 then
			task.wait(0.5)
		end

		local compileOk, compiled = pcall(loadstring, code)

		if not compileOk or not compiled then
			lastErr = "Compile error: " .. tostring(compiled)
			warn("[ETERNAL] Compile attempt " .. attempt .. " failed: " .. lastErr)
		else
			local runOk, runErr = pcall(compiled)

			if runOk then
				return true, nil
			else
				lastErr = "Runtime error: " .. tostring(runErr)
				warn("[ETERNAL] Runtime attempt " .. attempt .. " failed: " .. lastErr)
			end
		end
	end

	return false, lastErr
end

-- =============== AUTO DETECT & LOAD ===============
print("[ETERNAL] Game detected — PlaceId: " .. PlaceId)
print("[ETERNAL] Fetching script...")

local httpOk, response = SafeHttpGet(TargetURL, 3)

if not httpOk then
	warn("[ETERNAL] Failed to fetch script after retries: " .. tostring(response))
	return
end

if not response or #response < 5 then
	warn("[ETERNAL] Empty or invalid response received.")
	return
end

print("[ETERNAL] Script fetched (" .. #response .. " bytes). Executing...")

local execOk, execErr = SafeExecute(response, 2)

if execOk then
	print("[ETERNAL] Script executed successfully!")
else
	warn("[ETERNAL] Execution failed: " .. tostring(execErr))
end
