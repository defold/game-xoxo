local M = {}



local function index_to_row_column(index)
	local row = math.ceil(index / 3)
	local column = 1 + ((index - 1) % 3)
	return row, column
end

local function check_match(cells)
	local match = cells[1] ~= -1 and cells[1] == cells[2] and cells[1] == cells[3]
	if match then
		return cells[1]
	end
end

local function check_winner(state)
	local gs = state.cells
	local match_row =
	check_match(gs[1]
	or check_match(gs[2])
	or check_match(gs[3]))

	local match_column =
	-- down
	check_match({ gs[1][1], gs[2][1], gs[3][1] })
	or check_match({ gs[1][2], gs[2][2], gs[3][2] })
	or check_match({ gs[1][3], gs[2][3], gs[3][3] })
	-- across
	or check_match({ gs[1][1], gs[1][2], gs[1][3] })
	or check_match({ gs[2][1], gs[2][2], gs[2][3] })
	or check_match({ gs[3][1], gs[3][2], gs[3][3] })

	local match_cross =
	check_match({ gs[1][1], gs[2][2], gs[3][3] })
	or check_match({ gs[3][1], gs[2][2], gs[1][3] })

	local won = match_row or match_column or match_cross
	return won
end


local function check_draw(state)
	local gs = state.cells
	for i=1,9 do
		local row, column = index_to_row_column(i)
		if gs[row][column] == -1 then
			return false
		end
	end
	return true
end


function M.new_game()
	local state = {
		cells = {
			{ -1, -1, -1 },
			{ -1, -1, -1 },
			{ -1, -1, -1 },
		},
		players = {},
	}
	state.player_turn = 1
	return state
end

function M.add_player(state, player)
	assert(state)
	assert(#state.players < 2, "Game already has two players")
	state.players[#state.players + 1] = player
end

function M.player_move(state, row, column)
	assert(state)
	assert(#state.players == 2, "Game must have two players before a move can be made")
	if state.cells[row][column] == -1 then
		state.cells[row][column] = state.player_turn
		state.player_turn = (state.player_turn == 1) and 2 or 1
		state.draw = check_draw(state)
		state.winner = check_winner(state)
		return true
	else
		return false
	end
end

function M.get_player(state)
	assert(state)
	assert(#state.players == 2, "Game must have two players!")
	return state.players[state.player_turn]
end

function M.get_opponent(state)
	assert(state)
	assert(#state.players == 2, "Game must have two players!")
	return state.players[(state.player_turn == 1) and 2 or 1]
end

function M.dump(state)
	for r=1,3 do
		local c1 = state.cells[r][1]
		local c2 = state.cells[r][2]
		local c3 = state.cells[r][3]
		print(("[%02d][%02d][%02d]"):format(c1, c2, c3))
	end
end


return M