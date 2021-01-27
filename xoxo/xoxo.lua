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
	callback = wrap(callback)
	on_join_match_fn(function(success, message)
		assert(success ~= nil)
		assert(success or mesage)
		callback(success, message)
	end)
end

local match_update = nil
local on_match_update_fn
-- from server to client
function M.match_update(state, active_player, other_player, your_turn)
	assert(state)
	assert(active_player)
	assert(other_player)
	assert(your_turn ~= nil)
	match_update = {
		state = state,
		active_player = active_player,
		other_player = other_player,
		your_turn = your_turn,
	}
	if on_match_update_fn then
		on_match_update_fn(state, active_player, other_player, your_turn)
	end
end
-- client to server
function M.on_match_update(callback)
	on_match_update_fn = wrap(callback)
	if match_update then
		on_match_update_fn(
			match_update.state,
			match_update.active_player,
			match_update.other_player,
			match_update.your_turn)
	end
end

local on_send_player_move_fn
-- server to client
function M.on_send_player_move(fn)
	on_send_player_move_fn = fn
end
-- client to server
function M.send_player_move(row, column)
	on_send_player_move_fn(row, column)
end

local on_request_rematch_fn
-- server to client
function M.on_request_rematch(fn)
	on_request_rematch_fn = fn
end
-- client to server
function M.request_rematch()
	on_request_rematch_fn()
end


return M