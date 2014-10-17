--[[
	API: Update

	Update functionality for programs

	version: 0.1.1
	date: 17-10-2014
	author: Nathadir
]]

assert(os.loadAPI("API/github"), "Failed to load Github API.")

local meta = {
	version = {"0.1.1", 0, 1, 1},
	name = "API/update",
	pastebin = nil
}

-- Initialize
github.setMetaData({
	name = meta.name
})

function check(data)
	
end