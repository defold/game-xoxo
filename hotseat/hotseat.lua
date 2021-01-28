local game = require "xoxo.game.game"

local M = {}

local state = nil

function M.new_game()
	state = game.new_game()
	return state
end

function M.rematch()
	state = game.rematch(state)
	return state
end

function M.add_player(player)
	game.add_player(state, player)
	return state
end

function M.player_move(row, column)
	assert(state, "No game state exists! Have you loaded or started a new game?")
	return game.player_move(state, row, column)
end

function M.get_active_player()
	return game.get_active_player(state)
end

function M.get_other_player()
	return game.get_other_player(state)
end

function M.state()
	return state
end

function M.dump()
	game.dump(state)
end


return M