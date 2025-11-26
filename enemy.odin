package chase_in_space

import "core:fmt"
import "core:math/linalg"
import "vendor:sdl2"

Enemy :: struct {
	hp:             int,
	pos:            [2]f32,
	vel:            [2]f32,
	reload_counter: f32,
	bullet_decay:   f32,
	dash_counter:   f32,
}

make_enemies :: proc() -> [dynamic]Enemy {
	enemies := make([dynamic]Enemy)
	append(&enemies, Enemy{pos = {50.0, 50.0}, hp = 1})
	append(&enemies, Enemy{pos = {100.0, 100.0}, hp = 1})
	append(&enemies, Enemy{pos = {200.0, 200.0}, hp = 1})
	return enemies
}


update_enemy :: proc(enemy: ^Enemy, game: ^Game, dt: f32) {
	player := game.player
	dir := player.pos - enemy.pos
	dir = linalg.normalize0(dir)
	enemy.pos += dir * 0.12 * dt
	// Away from other enemies
	for _, i in game.enemies {
		if enemy != &game.enemies[i] {
			edir := enemy.pos - game.enemies[i].pos
			dis := linalg.length(edir)
			if dis > 0 {
				enemy.pos += edir * (1. / (dis * dis)) * 0.1 * dt
			}
		}
	}
	// Shoot
	if enemy.reload_counter <= 0 {
		append(
			&game.projectiles,
			Projectile{pos = enemy.pos, vel = 0.5 * dir, hp = 1, bullet_decay = 750},
		)
		enemy.reload_counter = 1000
	} else {
		enemy.reload_counter -= dt
	}
}

render_enemy :: proc(enemy: ^Enemy, game: ^Game) {
	sdl2.SetRenderDrawColor(game.renderer, 0, 255, 255, 0)
	sdl2.RenderDrawRectF(
		game.renderer,
		&sdl2.FRect{x = enemy.pos.x, y = enemy.pos.y, w = 10, h = 10},
	)

}

