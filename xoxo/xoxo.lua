local M = {}

local on_ready_fn
function M.on_ready(fn)
	on_ready_fn = fn
end
function M.ready(callback)
	on_ready_fn(callback)
end

local on_select_opponent_fn
function M.on_select_opponent(fn)
	on_select_opponent_fn = fn
end
function M.select_opponent(callback)
	on_select_opponent_fn(callback)
end


local on_get_opponent_fn
function M.on_get_opponent(fn)
	on_get_opponent_fn = fn
end
function M.get_opponent(callback)
	on_get_opponent_fn(callback)
end


local on_load_game_fn
function M.on_load_game(fn)
	on_load_game_fn = fn
end
function M.load_game(callback)
	on_load_game_fn(callback)
end


local on_player_move_fn
function M.on_player_move(fn)
	on_player_move_fn = fn
end
function M.player_move(row, column, callback)
	on_player_move_fn(row, column, callback)
end


local on_request_rematch_fn
function M.on_request_rematch(fn)
	on_request_rematch_fn = fn
end
function M.request_rematch(callback)
	on_request_rematch_fn(callback)
end


return M