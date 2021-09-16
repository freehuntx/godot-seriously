class_name Seriously
const ParserClass = preload("./ParserClass.gd")
const _ref = { parser = null }

static func _get_parser() -> ParserClass:
	if _ref.parser == null: _ref.parser = ParserClass.new()
	return _ref.parser

static func pack_to_buffer(value) -> PoolByteArray:
	return pack(value).data_array

static func unpack_from_buffer(buffer):
	var stream := StreamPeerBuffer.new()
	stream.set_data_array(buffer)
	return unpack(stream)

static func pack(value, stream := StreamPeerBuffer.new(), add_type := true) -> StreamPeerBuffer:
	return _get_parser().pack_type(typeof(value), value, stream, add_type)

static func unpack(stream: StreamPeerBuffer):
	return _get_parser().unpack_type(stream.get_u8(), stream)
