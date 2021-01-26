local gamestate = require "xoxo.game.state"

local M = {}

local state = nil

local function filename()
	return sys.get_save_file("xoxo", "save")
end

function M.load()
	state = sys.load(filename())
	if not next(state) then
		state = nil
	end
	return state
end

function M.save()
	sys.save(filename(), state)
end

function M.delete()
	sys.save(filename(), {})
end

function M.new_game()
	state = gamestate.new_game()
	M.save()
	return state
end

function M.add_player(player)
	gamestate.add_player(state, player)
	M.save()
	return state
end

function M.player_move(row, column)
	assert(state, "No game state exists! Have you loaded or started a new game?")
	local ok = gamestate.player_move(state, row, column)
	if ok then
		M.save()
	end
	return ok
end

function M.get_player()
	return gamestate.get_player(state)
end

function M.get_opponent()
	return gamestate.get_opponent(state)
end

function M.get_state()
	return state
end

function M.dump()
	gamestate.dump(state)
end


return M