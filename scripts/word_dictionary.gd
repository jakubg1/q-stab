extends Node

var words = {}
var badWords = {}

## Loads a word list from a file and returns a dict with the words as keys and `1` as value.
## Each word is a single line. Lines starting with # are ignored.
func loadList(path: String) -> Dictionary[String, int]:
	var file = FileAccess.open(path, FileAccess.READ)
	var result: Dictionary[String, int] = {}
	for word in file.get_as_text().split("\n"):
		if len(word) >= 3 and not word.begins_with("#"):
			result[word] = 1
	file.close()
	return result

## Checks if the specified word is valid and returns `true` if so, `false` otherwise.
func isWordValid(word: String) -> bool:
	return word in words or word in badWords

## Returns whether the specified word is a valid word that is not a bad word.
func isWordValidGood(word: String) -> bool:
	return word in words and not word in badWords

## Returns whether the specified word is a valid word that is a bad word.
func isWordValidBad(word: String) -> bool:
	return word in badWords

## Executed on start
func _ready() -> void:
	words = loadList("dictionary/en.txt")
	badWords = loadList("dictionary/en_bad.txt")
