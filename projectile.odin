package chase_in_space

import "core:fmt"
import "core:math/linalg"
import "vendor:sdl2"

Projectile :: struct {
	hp:             int,
	pos:            [2]f32,
	vel:            [2]f32,
	reload_counter: f32,
	bullet_decay:   f32,
	dash_counter:   f32,
}

update_projectile :: proc(projectile: ^Projectile, game: ^Game, dt: f32) {
	projectile.pos += projectile.vel * dt
	projectile.bullet_decay -= 1.0 * dt
	if projectile.bullet_decay < 0 {
		projectile.hp = 0
	} else {
		player := game.player
		if player.pos.x < projectile.pos.x &&
		   projectile.pos.x < player.pos.x + 10 &&
		   player.pos.y < projectile.pos.y &&
		   projectile.pos.y < player.pos.y + 10 {
			player.hp -= 1
			fmt.printf("HIT (HP: {})\n", player.hp)
			projectile.hp = 0
		}
	}
}

render_projectile :: proc(projectile: ^Projectile, game: ^Game) {
	sdl2.SetRenderDrawColor(game.renderer, 0, 255, 255, 0)
	sdl2.RenderDrawPointF(game.renderer, projectile.pos.x, projectile.pos.y)
}

