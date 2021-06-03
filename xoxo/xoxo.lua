local M = {}

local function wrap(callback)
	local instance = script.get_instance()
	return function(...)
		script.set_instance(instance)
		callback(...)
	end
end


local on_join_match_fn
-- called by backend proxy to subscribe to match join requests
function M.on_join_match(fn)
	on_join_match_fn = fn
end
-- called by xoxo when player wants to join a match
function M.join_match(callback)
	assert(on_join_match_fn, "You must call xoxo.on_join_match() from your backend proxy")
	callback = wrap(callback)
	on_join_match_fn(function(success, message)
		assert(success ~= nil)
		assert(success or message)
		callback(success, message)
	end)
end


local on_leave_match_fn
-- called by backend proxy to subscribe to match leave requests
function M.on_leave_match(fn)
	on_leave_match_fn = fn
end
-- called by xoxo when player wants to leave a match
function M.leave_match()
	assert(on_leave_match_fn, "You must call xoxo.on_leave_match() from your backend proxy")
	on_leave_match_fn()
end


local match_update = nil
local on_match_update_fn
-- called by backend proxy when match state has changed
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
-- called by xoxo to subscribe to match state changes
function M.on_match_update(callback)
	if not callback then
		on_match_update_fn = nil
		return
	end
	on_match_update_fn = wrap(callback)
	if match_update then
		on_match_update_fn(
			match_update.state,
			match_update.active_player,
			match_update.other_player,
			match_update.your_turn)
	end
end

local on_opponent_left_fn = nil
-- called by backend proxy when opponent left match
function M.opponent_left()
	if on_opponent_left_fn then
		on_opponent_left_fn()
	end
end
-- called by xoxo to subscribe to when the opponent leaves a match 
function M.on_opponent_left(callback)
	if not callback then
		on_opponent_left_fn = nil
		return
	end
	on_opponent_left_fn = wrap(callback)
end


local on_send_player_move_fn = nil
-- called by backend proxy to subscribe to player move attempts
function M.on_send_player_move(fn)
	on_send_player_move_fn = fn
end
-- called by xoxo when the player wants to send a move
function M.send_player_move(row, column)
	assert(on_send_player_move_fn, "You must call xoxo.on_send_player_move() from your backend proxy")
	on_send_player_move_fn(row, column)
end

local connected = false
local on_show_menu_fn = nil
local on_show_game_fn = nil

-- called by xoxo to get notified that it should navigate to the menu
function M.on_show_menu(fn)
	on_show_menu_fn = wrap(fn)
end
-- called by xoxo to get notified that it should navigate to the game
function M.on_show_game(fn)
	on_show_game_fn = wrap(fn)
end

-- called by backend proxy when connected and ready to transition to the menu
function M.show_menu()
	connected = true
	on_show_menu_fn()
end

-- called by backend proxy when connected and ready to transition to the game
-- this is used in reconnected or other cases when the game is started with an
-- active game
function M.show_game()
	connected = true
	on_show_game_fn()
end


-- called by backend proxy to get notified when it should connect
local on_connect_fn = nil
function M.on_connect(fn)
	on_connect_fn = wrap(fn)
end

-- called by xoxo when requesting backend proxy to connect
function M.connect()
	assert(on_connect_fn, "You must call xoxo.on_connect() from your backend proxy")
	on_connect_fn()
end

local on_disconnected_fn = nil
-- called by xoxo to get notified when the connection has been disconnected
function M.on_disconnected(fn)
	on_disconnected_fn = wrap(fn)
end
-- called by the backend proxy when it has disconnected
function M.disconnected()
	connected = false
	on_disconnected_fn()
end

function M.is_connected()
	return connected
end
return M