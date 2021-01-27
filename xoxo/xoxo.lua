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
	on_join_match_fn(function()
		callback()
	end)
end

local on_request_match_state_fn
function M.on_request_match_state(fn)
	on_request_match_state_fn = fn
end
function M.request_match_state(callback)
	callback = wrap(callback)
	on_request_match_state_fn(function(state, active_player, other_player, your_turn)
		assert(state)
		assert(active_player)
		assert(other_player)
		assert(your_turn ~= nil)
		callback(state, active_player, other_player, your_turn)
	end)
end

local on_send_player_move_fn
function M.on_send_player_move(fn)
	on_send_player_move_fn = fn
end
function M.send_player_move(row, column, callback)
	callback = wrap(callback)
	on_send_player_move_fn(row, column, function(state, active_player, other_player, your_turn)
		assert(state)
		assert(active_player)
		assert(other_player)
		assert(your_turn ~= nil)
		callback(state, active_player, other_player, your_turn)
	end)
end

local on_request_rematch_fn
function M.on_request_rematch(fn)
	on_request_rematch_fn = fn
end
function M.request_rematch(callback)
	callback = wrap(callback)
	on_request_rematch_fn(function(state, active_player, other_player, your_turn)
		assert(state)
		assert(active_player)
		assert(other_player)
		assert(your_turn ~= nil)
		callback(state, active_player, other_player, your_turn)
	end)
end


return M