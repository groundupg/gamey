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
update_player :: proc(entity: ^Entity, game: ^Game, dt: f32) {
	dir := [2]f32{0, 0}
	if b8(game.keyboard[sdl2.SCANCODE_UP]) | b8(game.keyboard[sdl2.SCANCODE_W]) {dir.y -= 1}
	if b8(game.keyboard[sdl2.SCANCODE_DOWN]) | b8(game.keyboard[sdl2.SCANCODE_S]) {dir.y += 1}
	if b8(game.keyboard[sdl2.SCANCODE_LEFT]) | b8(game.keyboard[sdl2.SCANCODE_A]) {dir.x -= 1}
	if b8(game.keyboard[sdl2.SCANCODE_RIGHT]) | b8(game.keyboard[sdl2.SCANCODE_D]) {dir.x += 1}
	dir = linalg.normalize0(dir)
	entity.pos += dir * 0.2 * dt
	// Dash
	if b8(game.keyboard[sdl2.SCANCODE_LSHIFT]) && entity.dash_counter == 0 && dir != 0 {
		entity.vel = dir * 5.0
		entity.dash_counter += 150
	} else {
		entity.dash_counter = max(entity.dash_counter - dt, 0)
	}
	entity.pos += entity.vel * dt
	entity.vel -= entity.vel * 0.9999 / dt
	// Keep it in the map
	entity.pos.x = clamp(entity.pos.x, 0, 640 - 10)
	entity.pos.y = clamp(entity.pos.y, 0, 480 - 10)
}

