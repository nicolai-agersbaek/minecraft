--[[
	API: Github

	Adds support for downloading programs and code-snippet from github

	version: 0.1.1
	date: 17-10-2014
	author: Nathadir
]]

local meta = {
	version = {"0.1.3", 0, 1, 3},
	name = "API/github",
	github = {
		user = "nicolai-agersbaek",
		repository = "minecraft",
		name = nil
	}
}

local assert(condition, str)
	if str then
		assert(condition, "["..meta.name.."]: "..str)
	else
		assert(condition, "["..meta.name.."]")
	end
end

local error(str)
	error("["..meta.name.."]: "..str)
end

function setMetaData(data)
	assert(data.name, "Argument 'name' not specified for function setMetaData()!")

	meta.github.name = data.name
	meta.github.user = data.user or meta.github.user
	meta.github.repository = data.repository or meta.github.user
end

function get(data)
	assert(data.name or meta.github.name, "Argument 'name' not specified for function get()!")

	local name = data.name or meta.github.name
	local user = data.user or meta.github.user
	local repository = data.repository or meta.github.repository

	local url = "https://raw.githubusercontent.com/" .. user .. "/master/" .. repository .. "/" .. name .. ".lua"
	local raw = http.get(url)
	local responseCode = raw.getResponseCode()

	assert(responseCode == 200, "HTTP request failed with a response code of "..responseCode..".")

	return raw
end

function run(data)
	local fileContent = get(data)

	-- Check if temporary file exists
	if fs.exists("github-tmp") then
		error("Temporary file for running program from Github already exists!")
	end

	-- Create file in write-mode and copy http response to it
	local fh = fs.open("github-tmp", "w")
	fh.write(fileContent.readAll())

	-- Run program
	shell.run("github-tmp")

	-- Delete temporary file
	shell.run("delete", "github-tmp")
end

function save(data, path, override)
	local fileContent = get(data)

	-- Check if file already exists at location
	if fs.exists(path) and not override then
		error("Filepath to save at already exists (override not set)!")
	end

	-- Remove existing file if it exists
	shell.run("delete", path)
	local fh = fs.open(path, "w")

	fh.write(fileContent.readAll())
	fh.close()
end

function saveAndRun(data, path, override)
	save(data, path, override)

	shell.run(path)
end