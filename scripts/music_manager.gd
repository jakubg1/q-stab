extends Node

@onready var TRACKS: Dictionary[String, Music] = {
	"title": $Title,
	"level": $Level
}

## Stops all music.
func stop(duration: float = 0) -> void:
	for track in TRACKS:
		TRACKS[track].stopFadeout(duration)

## Plays the specified track and mutes all other tracks.
func play(trackName: String, duration: float = 0) -> void:
	stop()
	TRACKS[trackName].playFadein(0)

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
