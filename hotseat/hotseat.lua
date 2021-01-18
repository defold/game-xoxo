local gamestate = require "xoxo.game.state"

local M = {}

local function filename()
	return sys.get_save_file("xoxo", "save")
end

function M.load()
	local state = sys.load(filename())
	if not next(state) then
		state = nil
	end
	gamestate.set(state)
	return state
end

function M.save()
	sys.save(filename(), gamestate.get())
end

function M.delete()
	sys.save(filename(), {})
end


function M.reset()
	gamestate.reset()
end


function M.new_game(player1, player2)
	gamestate.new_game(player1, player2)
	M.save()
end

function M.player_move(row, column)
	local ok = gamestate.player_move(row, column)
	if ok then
		M.save()
	end
	return ok
end

function M.get_player()
	return gamestate.get_player()
end

function M.get_opponent()
	return gamestate.get_opponent()
end

function M.get_state()
	return gamestate.get()
end

function M.dump()
	gamestate.dump()
end


return M