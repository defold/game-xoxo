local M = {}

local function wrap(callback)
	local instance = script.get_instance()
	return function(...)
		script.set_instance(instance)
		callback(...)
	end
end


local on_join_match_fn
function M.on_join_match(fn)
	on_join_match_fn = fn
end
function M.join_match(callback)
	on_join_match_fn(wrap(callback))
end

local on_request_match_state_fn
function M.on_request_match_state(fn)
	on_request_match_state_fn = fn
end
function M.request_match_state(callback)
	on_request_match_state_fn(wrap(callback))
end

local on_send_player_move_fn
function M.on_send_player_move(fn)
	on_send_player_move_fn = fn
end
function M.send_player_move(row, column, callback)
	on_send_player_move_fn(row, column, wrap(callback))
end

local on_request_rematch_fn
function M.on_request_rematch(fn)
	on_request_rematch_fn = fn
end
function M.request_rematch(callback)
	on_request_rematch_fn(wrap(callback))
end


return M