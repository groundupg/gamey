package chase_in_space

import "core:fmt"
import "core:math/linalg"
import "vendor:sdl2"

EntityType :: enum {
	PLAYER,
	ENEMY,
	PROJECTILE,
}

Entity :: struct {
	type:           EntityType,
	hp:             int,
	pos:            [2]f32,
	vel:            [2]f32,
	reload_counter: f32,
	bullet_decay:   f32,
	dash_counter:   f32,
}

update_entity :: proc(entity: ^Entity, game: ^Game) {
	dt := f32(game.dt)
	switch entity.type {
	case .PLAYER:
		update_player(entity, game, dt)
	case .ENEMY:
		update_enemy(entity, game, dt)
	case .PROJECTILE:
		update_projectile(entity, game, dt)
	}
}


render_player :: proc(entity: ^Entity, game: ^Game) {
	sdl2.SetRenderDrawColor(game.renderer, 255, 0, 255, 0)
	sdl2.RenderDrawRectF(
		game.renderer,
		&sdl2.FRect{x = entity.pos.x, y = entity.pos.y, w = 10, h = 10},
	)
}

render_enemy :: proc(entity: ^Entity, game: ^Game) {
	sdl2.SetRenderDrawColor(game.renderer, 0, 255, 255, 0)
	sdl2.RenderDrawRectF(
		game.renderer,
		&sdl2.FRect{x = entity.pos.x, y = entity.pos.y, w = 10, h = 10},
	)

}

render_projectile :: proc(entity: ^Entity, game: ^Game) {
	sdl2.SetRenderDrawColor(game.renderer, 0, 255, 255, 0)
	sdl2.RenderDrawPointF(game.renderer, entity.pos.x, entity.pos.y)
}

render_entity :: proc(entity: ^Entity, game: ^Game) {
	switch entity.type {
	case .PLAYER:
		render_player(entity, game)
	case .ENEMY:
		render_enemy(entity, game)
	case .PROJECTILE:
		render_projectile(entity, game)
	}
}

find_entity :: proc(type: EntityType, game: ^Game) -> ^Entity {
	for _, i in game.entities {
		if game.entities[i].type == type {
			return &game.entities[i]
		}
	}
	return nil
}

