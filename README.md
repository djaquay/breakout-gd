# Breakout

Part of the 20-Game Challenge

## Up Next/The Plan

* more room at the top and sides, for better bounces

Bugs

* 2nd seam test fails, perhaps because ball goes _into_ the brick before reversing direction?

In the queue

* improved visuals (add colors, bevels)
* additional styles/behaviors of bricks (e.g. extra balls)
	* motion (gradual up/down; alternating left/right)
* better player control
	* angle control based on location of impact
	* ball capture/release (perhaps as temporary brick-rewarded buff)

## Done

* basic scene structure
* basic visual scene elements (walls, HUD, player, ball, bricks)
* mechanical scene elements (collision rects, etc.)
* brick setup, addition
* push repo to gh
* player movement (mouse-driven, x-axis)
* ball service/movement
* wall collision
* brick collision
* brick removal
* scorekeeping
* ball-loss detection
* three lives
* added 2nd lives-left display
* start/end of game logic, display
* speed increase
* add new set of bricks when 1st set is cleared
* high score
