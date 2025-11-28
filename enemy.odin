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


update_enemy :: proc(entity: ^Entity, game: ^Game, dt: f32) {
	player := find_entity(.PLAYER, game)
	if player == nil {return}
	dir := player.pos - entity.pos
	dir = linalg.normalize0(dir)
	entity.pos += dir * 0.12 * dt
	// Away from other enemies
	for _, i in game.entities {
		if game.entities[i].type == .ENEMY && entity != &game.entities[i] {
			edir := entity.pos - game.entities[i].pos
			dis := linalg.length(edir)
			if dis > 0 {
				entity.pos += edir * (1. / (dis * dis)) * 0.1 * dt
			}
		}
	}
	// Shoot
	if entity.reload_counter <= 0 {
		append(
			&game.entities,
			Entity {
				type = .PROJECTILE,
				pos = entity.pos,
				vel = 0.5 * dir,
				hp = 1,
				bullet_decay = 750,
			},
		)
		entity.reload_counter = 1000
	} else {
		entity.reload_counter -= dt
	}
}

