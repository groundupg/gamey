package chase_in_space

import "core:fmt"
import "core:math/linalg"
import "vendor:sdl2"

Player :: struct {
	hp:             int,
	pos:            [2]f32,
	vel:            [2]f32,
	reload_counter: f32,
	bullet_decay:   f32,
	dash_counter:   f32,
}

make_player :: proc() -> Player {
	return Player{pos = {50.0, 400.0}, hp = 10}
}

update_player :: proc(player: ^Player, game: ^Game, dt: f32) {
	dir := [2]f32{0, 0}
	if b8(game.keyboard[sdl2.SCANCODE_UP]) | b8(game.keyboard[sdl2.SCANCODE_W]) {dir.y -= 1}
	if b8(game.keyboard[sdl2.SCANCODE_DOWN]) | b8(game.keyboard[sdl2.SCANCODE_S]) {dir.y += 1}
	if b8(game.keyboard[sdl2.SCANCODE_LEFT]) | b8(game.keyboard[sdl2.SCANCODE_A]) {dir.x -= 1}
	if b8(game.keyboard[sdl2.SCANCODE_RIGHT]) | b8(game.keyboard[sdl2.SCANCODE_D]) {dir.x += 1}
	dir = linalg.normalize0(dir)
	player.pos += dir * 0.2 * dt
	// Dash
	if b8(game.keyboard[sdl2.SCANCODE_LSHIFT]) && player.dash_counter == 0 && dir != 0 {
		player.vel = dir * 5.0
		player.dash_counter += 150
	} else {
		player.dash_counter = max(player.dash_counter - dt, 0)
	}
	player.pos += player.vel * dt
	player.vel -= player.vel * 0.9999 / dt
	// Keep it in the map
	player.pos.x = clamp(player.pos.x, 0, 640 - 10)
	player.pos.y = clamp(player.pos.y, 0, 480 - 10)
}

render_player :: proc(player: ^Player, game: ^Game) {
	sdl2.SetRenderDrawColor(game.renderer, 255, 0, 255, 0)
	sdl2.RenderDrawRectF(
		game.renderer,
		&sdl2.FRect{x = player.pos.x, y = player.pos.y, w = 10, h = 10},
	)
}

