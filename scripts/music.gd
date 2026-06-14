extends AudioStreamPlayer
class_name Music

var volume := 0.0 ## In percentage
var targetVolume := 0.0 ## In percentage
var volumeSpeed := 0.0

## Starts playing the music with a fade in.
func playFadein(duration: float = 0) -> void:
	if targetVolume == 1:
		return
	targetVolume = 1
	if duration == 0:
		volume = 1
	else:
		volumeSpeed = 1.0 / duration

## Stops playing the music with a fade out.
func stopFadeout(duration: float = 0) -> void:
	if targetVolume == 0:
		return
	targetVolume = 0
	if duration == 0:
		volume = 0
	else:
		volumeSpeed = 1.0 / duration

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if volume < targetVolume:
		volume = min(targetVolume, volume + volumeSpeed * delta)
	elif volume > targetVolume:
		volume = max(targetVolume, volume - volumeSpeed * delta)
	if volume == 0 and playing:
		stop()
	elif volume > 0 and not playing:
		play()
	volume_linear = volume
