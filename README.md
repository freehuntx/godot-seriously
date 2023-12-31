# Seriously - A de-/serializer for godot
There are some things i didnt like about the godot serialization api. So i came up with an own one.  
While its not faster than the godot serialization api, it produces smaller byte arrays thus uses less traffic.  
Plus you dont have the security issue of functions executing when you want to serialize objects.

**Tested on Godot 4.2**

## Installation
- Copy addons folder into your godot project

## API

- Seriously
  - pack_to_bytes (value): PoolByteArray
  - unpack_from_bytes (bytes: PackedByteArray)
  - pack (value): StreamPeerBuffer
  - unpack (stream: StreamPeerBuffer)

## Example

### Serialization

```
var bytes := Seriously.pack_to_bytes([ "example", true, false, 1, 1.3, {}, Object.new() ])
```

### Deserialization

```
var bytes := Seriously.pack_to_bytes([ "example", true, false, 1, 1.3, {}, Object.new() ])
var data = Seriously.unpack_from_bytes(bytes)
```
## Test
<details>
<summary>Test code</summary>

```
func _init():
	var test_data = {
		"some_key": {
			"some_other_key": [
				1,
				false,
				0.1,
				Color.RED,
				Vector4.ZERO,
				Plane(10, 10, 10, 10)
			],
			"yet_another_key": SceneMultiplayer.new()
		}
	}

	# Godot serialization api
	var start_time = Time.get_ticks_usec()
	print("# Godot serialization api")
	var bytes = var_to_bytes(test_data)
	print()
	print("## Bytes (%s)" % [bytes.size()])
	print(bytes)
	print()
	print("## Parsed")
	print(bytes_to_var(bytes))
	print()
	print("## Result")
	print(float(Time.get_ticks_usec() - start_time) / 1000.0, "m/s")
	print("--------------------")
	# Seriously api
	start_time = Time.get_ticks_usec()
	print("# Seriously api")
	bytes = Seriously.pack_to_bytes(test_data)
	print()
	print("## Bytes (%s)" % [bytes.size()])
	print(bytes)
	print()
	print("## Parsed")
	print(Seriously.unpack_from_bytes(bytes))
	print()
	print("## Result")
	print(float(Time.get_ticks_usec() - start_time) / 1000.0, "m/s")
```
</details>  
<br />
<details>
<summary>Result</summary>

```
# Godot serialization api

## Bytes (188)
[27, 0, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 8, 0, 0, 0, 115, 111, 109, 101, 95, 107, 101, 121, 27, 0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 14, 0, 0, 0, 115, 111, 109, 101, 95, 111, 116, 104, 101, 114, 95, 107, 101, 121, 0, 0, 28, 0, 0, 0, 6, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 3, 0, 1, 0, 154, 153, 153, 153, 153, 153, 185, 63, 20, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 63, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 32, 65, 0, 0, 32, 65, 0, 0, 32, 65, 0, 0, 32, 65, 4, 0, 0, 0, 15, 0, 0, 0, 121, 101, 116, 95, 97, 110, 111, 116, 104, 101, 114, 95, 107, 101, 121, 0, 24, 0, 1, 0, 197, 4, 0, 144, 5, 0, 0, 128]

## Parsed
{ "some_key": { "some_other_key": [1, false, 0.1, (1, 0, 0, 1), (0, 0, 0, 0), [N: (10, 10, 10), D: 10]], "yet_another_key": <EncodedObjectAsID#-9223372012863355697> } }

## Result
0.3m/s
--------------------
# Seriously api

## Bytes (107)
[27, 1, 0, 8, 0, 115, 111, 109, 101, 95, 107, 101, 121, 27, 2, 0, 14, 0, 115, 111, 109, 101, 95, 111, 116, 104, 101, 114, 95, 107, 101, 121, 28, 6, 0, 50, 1, 1, 0, 3, 154, 153, 153, 153, 153, 153, 185, 63, 20, 255, 0, 0, 255, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 32, 65, 0, 0, 32, 65, 0, 0, 32, 65, 0, 0, 32, 65, 15, 0, 121, 101, 116, 95, 97, 110, 111, 116, 104, 101, 114, 95, 107, 101, 121, 24, 0, 0]

## Parsed
{ "some_key": { "some_other_key": [1, false, 0.1, (1, 0, 0, 1), (0, 0, 0, 0), [N: (10, 10, 10), D: 10]], "yet_another_key": <RefCounted#-9223372012796246831> } }

## Result
0.973m/s
```
</details>