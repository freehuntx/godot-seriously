# Seriously - A de-/serializer for godot

## Installation

- Copy addons folder into your godot project

## API

- Seriously
  - pack_to_buffer (value: Variant): PoolByteArray
  - unpack_from_buffer (buffer: Array): Variant
  - pack (value: Variant, stream: StreamPeerBuffer, add_type: boolean):
    StreamPeerBuffer
  - unpack (stream: StreamPeerBuffer): Variant

## Example

### Serialization

```
# We wil pack any data into a stream
var stream = Seriously.pack([ "example", true, false, 1, 1.3, {} ])
# We get the byte array from the stream
var buffer = stream.data_array
```

### Deserialization

```
var stream = Seriously.pack([ "example", true, false, 1, 1.3, {} ])
var data = Seriously.unpack(stream)
```
