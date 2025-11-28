# Stream of Consciousness

This file is a *stream of consciousness* -- entries may take the appearance of documentation, planning,
thinking; however, the purpose of this file is discovery.

## 28.11.25

After receiving a copy of the raw *chase in space* program, and attempting to make changes, I
am becoming aware of my lack of knowledge of the procedures within the game.

What I originally homed in on was the `Entity` struct, and related functions. My thinking was
that the `Entity` struct could be separated into the 3 types of entities defined in the
enum for `entities.type`. Regarding the functionality -- which appeared as conditionals that would
switch on `entity.type` -- these could all be replaced by unique functions to the specific
entity.
This started off well. The `case` statements within the `switch` statements were replaced by
unique functions. Issues occured, however, when I looked to remove the `Entity` struct and
replace every bit of functionality which used it with functionality related to the specific
entity the functionality was related to.
The program ran, yes, but it was extremely slow -- entities were moving on the movement of my mouse
while keyboard actions resulted in snail-paced movements.

It was at this moment I became viscerally aware of the fact that I had no idea what the program
was actually doing. I didn't change the tick rate stuff, did I??
I, being unaware of what actually happens on the execution of this program, found myself
making small tweaks, and re-running the program to see if the change worked; I even found myself
prompting what the cause may be on ChatGPT!

When has understanding ever been gained through such means....

I would now care to understand how this program works.
More generally, I would like to understand how the main event loop of a game works.

### Understanding a Game

First, before I dive into the code, I ought to ask 'How might a game work?'.
The programs I deal with describe computations which are performed in a sequential manner, a game
here is no different.

I will look to make statements about this game, in attempt of understanding how it may work.

1. This game will run forever, only exiting on cancellation of the program execution.

2. A Window is created, the size of which spanning a fraction of the pixel dimensions of the
    given monitor of the computer it was executed on.

3. 2 *types* of square shapes are displayed on the window -- a single small pink square (P) and 3
    small blue squares (E or 3E). All shapes are displayed at different points of the window.

4. As time passes, 3E appears to travel toward the window location of P.

5. As time passes, many instances of another type of shape is displayed on the window -- A small white line (L).

6. In a given increment of time (tL), 3L are displayed, appearing to travel in a straight line
  from the location of a given E to the current location of P.

7. If an L comes within the dimensions of the pink square of P, a HP counter, starting at 9,
    is displayed in stdout.

8. If HP == 0, P is removed from the window.

9. The location of P changes based upon the keyboard movements of the user through the left, up,
    down, and right arrow keys, respectively travelling across the screen in a given direction.


It is obvious that the notion of time is very important in this program. There must be a time `t`
where each rendering of shape occurs.

```go
type Quad {
    x1 int // Pixel location
    y1 int
    x2 int
    y2 int
}
type Line {
  x int
  y int
}

const (
  up Direction = iota
  down
  left
  right
)

const window Quad = (0, 0, 640, 480) // 640x480
const P Quad = (10, 10, 15, 15) // 5x5
const E1 Quad = (600, 600, 605, 605) // ...
const E2 Quad = (550, 550, 555, 555)
const E3 Quad = (575, 575, 580, 580)

const tL float = 1 // Time Taken for an L to move to a new pixel location after rendering
const tP float = 2 // Time Taken for P to move to a new pixel location after a keyboard press
const tE float = 2 // Time taken for E to move to a new pixel location
const tLE float = 4 // Time taken for a new L to render
const hp integer = 10

func RenderQuad(q Quad, m Monitor)
func RenderLine(l Line, m Monitor)

// Moves P in a given direction
func MoveP(k Keyboard, m Monitor) {
  switch k.input() {
    case up:
      if P.y2+1 != window.y2{
        P.y1, P.y2 += 1
      }
    case down:
      if P.y1 - 1 != window.y1 {
        P.y1, P.y2 -= 1
      }
    case left:
      if P.x1 - 1 != window.x1 {
        P.x1, P.x2 -= 1
      }
    case right:
      if P.x2 + 1 != window.x2 {
        P.x1, P.x2 += 1
      }
  }
  RenderQuad(P, m)
}


func main() {
  m := os.GetMonitor()
  k := os.GetKeyboard()
  RenderQuad(window, m)
  RenderQuad(P, m)
  RenderQuad(E1, m)
  RenderQuad(E2, m)
  RenderQuad(E3, m)
  for { // infinite loop
        if k.pressed {
      os.time.wait(tP)
      MoveP()
    }
    MoveE(E1, m)
    MoveE(E2, m)
    MoveE(E3, m)
  }
}
```

Now I'm beginning to struggle. I was able to reason with regards to the shapes that are displayed;
I understand the functionality with regards to where the new pixel location of a given P, E, or L may
be. What I am struggling with is the aspect of time in this sequential program.


