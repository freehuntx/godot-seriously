class_name Seriously extends RefCounted

enum CustomTypes {
	UINT8 = 50,
	INT8 = 51,
	UINT16 = 52,
	INT16 = 53,
	UINT32 = 54,
	INT32 = 55,
	UINT64 = 56,
	INT64 = 57,
	TYPED_ARRAY = 58
}

static var _serializer = {
	TYPE_NIL: {
		"pack": func(_value, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			return stream,
		"unpack": func(_stream: StreamPeerBuffer):
			return null,
	},
	TYPE_BOOL: {
		"pack": func(value: bool, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u8(1 if value else 0)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> bool:
			return stream.get_u8() > 0,
	},
	TYPE_INT: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_32(),
	},
	CustomTypes.UINT8: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u8(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_u8(),
	},
	CustomTypes.INT8: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_8(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_8(),
	},
	CustomTypes.UINT16: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_u16(),
	},
	CustomTypes.INT16: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_16(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_16(),
	},
	CustomTypes.UINT32: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u32(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_u32(),
	},
	CustomTypes.INT32: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_32(),
	},
	CustomTypes.UINT64: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u64(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_u64(),
	},
	CustomTypes.INT64: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_64(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_64(),
	},
	TYPE_FLOAT: {
		"pack": func(value: float, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_double(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> float:
			return stream.get_double(),
	},
	TYPE_STRING: {
		"pack": func(value: String, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var bytes = value.to_utf8_buffer()
			_put_dynamic_int(bytes.size(), stream)
			stream.put_data(bytes)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> String:
			return stream.get_utf8_string(_get_dynamic_int(stream)),
	},
	TYPE_VECTOR2: {
		"pack": func(value: Vector2, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.x)
			stream.put_float(value.y)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector2:
			return Vector2(stream.get_float(), stream.get_float()),
	},
	TYPE_VECTOR2I: {
		"pack": func(value: Vector2i, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value.x)
			stream.put_32(value.y)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector2i:
			return Vector2i(stream.get_32(), stream.get_32()),
	},
	TYPE_RECT2: {
		"pack": func(value: Rect2, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.position.x)
			stream.put_float(value.position.y)
			stream.put_float(value.size.x)
			stream.put_float(value.size.y)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Rect2:
			return Rect2(stream.get_float(), stream.get_float(), stream.get_float(), stream.get_float()),
	},
	TYPE_RECT2I: {
		"pack": func(value: Rect2i, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value.position.x)
			stream.put_32(value.position.y)
			stream.put_32(value.size.x)
			stream.put_32(value.size.y)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Rect2i:
			return Rect2i(stream.get_32(), stream.get_32(), stream.get_32(), stream.get_32()),
	},
	TYPE_VECTOR3: {
		"pack": func(value: Vector3, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.x)
			stream.put_float(value.y)
			stream.put_float(value.z)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector3:
			return Vector3(stream.get_float(), stream.get_float(), stream.get_float()),
	},
	TYPE_VECTOR3I: {
		"pack": func(value: Vector3i, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value.x)
			stream.put_32(value.y)
			stream.put_32(value.z)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector3i:
			return Vector3i(stream.get_32(), stream.get_32(), stream.get_32()),
	},
	TYPE_TRANSFORM2D: {
		"pack": func(value: Transform2D, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.x, stream, TYPE_VECTOR2)
			pack(value.y, stream, TYPE_VECTOR2)
			pack(value.origin, stream, TYPE_VECTOR2)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Transform2D:
			return Transform2D(unpack(stream, TYPE_VECTOR2), unpack(stream, TYPE_VECTOR2), unpack(stream, TYPE_VECTOR2)),
	},
	TYPE_VECTOR4: {
		"pack": func(value: Vector4, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.x)
			stream.put_float(value.y)
			stream.put_float(value.z)
			stream.put_float(value.w)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector4:
			return Vector4(stream.get_float(), stream.get_float(), stream.get_float(), stream.get_float()),
	},
	TYPE_VECTOR4I: {
		"pack": func(value: Vector4i, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value.x)
			stream.put_32(value.y)
			stream.put_32(value.z)
			stream.put_32(value.w)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector4i:
			return Vector4i(stream.get_32(), stream.get_32(), stream.get_32(), stream.get_32()),
	},
	TYPE_PLANE: {
		"pack": func(value: Plane, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.normal, stream, TYPE_VECTOR3)
			stream.put_float(value.d)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Plane:
			return Plane(unpack(stream, TYPE_VECTOR3), stream.get_float()),
	},
	TYPE_QUATERNION: {
		"pack": func(value: Quaternion, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.x)
			stream.put_float(value.y)
			stream.put_float(value.z)
			stream.put_float(value.w)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Quaternion:
			return Quaternion(stream.get_float(), stream.get_float(), stream.get_float(), stream.get_float()),
	},
	TYPE_AABB: {
		"pack": func(value: AABB, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.position, stream, TYPE_VECTOR3)
			pack(value.size, stream, TYPE_VECTOR3)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> AABB:
			return AABB(unpack(stream, TYPE_VECTOR3), unpack(stream, TYPE_VECTOR3)),
	},
	TYPE_BASIS: {
		"pack": func(value: Basis, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.x, stream, TYPE_VECTOR3)
			pack(value.y, stream, TYPE_VECTOR3)
			pack(value.z, stream, TYPE_VECTOR3)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Basis:
			return Basis(unpack(stream, TYPE_VECTOR3), unpack(stream, TYPE_VECTOR3), unpack(stream, TYPE_VECTOR3)),
	},
	TYPE_TRANSFORM3D: {
		"pack": func(value: Transform3D, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.basis, stream, TYPE_BASIS)
			pack(value.origin, stream, TYPE_VECTOR3)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Transform3D:
			return Transform3D(unpack(stream, TYPE_BASIS), unpack(stream, TYPE_VECTOR3)),
	},
	TYPE_PROJECTION: {
		"pack": func(value: Projection, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.x, stream, TYPE_VECTOR4)
			pack(value.y, stream, TYPE_VECTOR4)
			pack(value.z, stream, TYPE_VECTOR4)
			pack(value.w, stream, TYPE_VECTOR4)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Projection:
			return Projection(unpack(stream, TYPE_VECTOR4), unpack(stream, TYPE_VECTOR4), unpack(stream, TYPE_VECTOR4), unpack(stream, TYPE_VECTOR4)),
	},
	TYPE_COLOR: {
		"pack": func(value: Color, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u32(value.to_rgba32())
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Color:
			return Color(stream.get_u32()),
	},
	TYPE_STRING_NAME: {
		"pack": func(value: StringName, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(str(value), stream, TYPE_STRING)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> StringName:
			return StringName(unpack(stream, TYPE_STRING)),
	},
	TYPE_NODE_PATH: {
		"pack": func(value: NodePath, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(str(value), stream, TYPE_STRING)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> NodePath:
			return NodePath(unpack(stream, TYPE_STRING)),
	},
	TYPE_RID: {
		"pack": func(_value: RID, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			push_error("[Seriously] TYPE_RID is not supported")
			return stream,
		"unpack": func(_stream: StreamPeerBuffer):
			push_error("[Seriously] TYPE_RID is not supported")
			return null,
	},
	TYPE_OBJECT: {
		"pack": func(value: Object, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var prop_names = value.get_property_list().filter(func(p): return p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE).map(func(p): return p.name)
			_put_dynamic_int(prop_names.size(), stream)
			
			for name in prop_names:
				pack(name, stream, TYPE_STRING)
				pack(value.get(name), stream)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Dictionary:
			var object_size = _get_dynamic_int(stream)
			var dict := {}
			
			for j in object_size:
				var name = unpack(stream, TYPE_STRING)
				dict[name] = unpack(stream)
				
			return dict,
	},
	TYPE_CALLABLE: {
		"pack": func(_value: Callable, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			push_error("[Seriously] TYPE_CALLABLE type pack requested. This is not possible!")
			return stream,
		"unpack": func(_stream: StreamPeerBuffer):
			push_error("[Seriously] TYPE_CALLABLE type unpack requested. This is not possible!")
			return null,
	},
	TYPE_SIGNAL: {
		"pack": func(_value: Signal, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			push_error("[Seriously] TYPE_SIGNAL type pack requested. This is not possible!")
			return stream,
		"unpack": func(_stream: StreamPeerBuffer):
			push_error("[Seriously] TYPE_SIGNAL type unpack requested. This is not possible!")
			return null,
	},
	TYPE_DICTIONARY: {
		"pack": func(value: Dictionary, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			_put_dynamic_int(value.size(), stream)
			for key in value.keys():
				pack(key, stream)
				pack(value[key], stream)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Dictionary:
			var dictionary_size = _get_dynamic_int(stream)
			var dictionary = {}
			for j in dictionary_size:
				var key = unpack(stream)
				dictionary[key] = unpack(stream)
			return dictionary,
	},
	TYPE_ARRAY: {
		"pack": func(value: Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			_put_dynamic_int(value.size(), stream)
			for item in value:
				pack(item, stream)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Array:
			var array_size = _get_dynamic_int(stream)
			var array = []
			for i in array_size:
				array.append(unpack(stream))
			return array,
	},
	TYPE_PACKED_BYTE_ARRAY: {
		"pack": func(value: PackedByteArray, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			_put_dynamic_int(value.size(), stream)
			stream.put_data(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedByteArray:
			var array_size = _get_dynamic_int(stream)
			var data = stream.get_data(array_size)[1]
			return PackedByteArray(data),
	},
	TYPE_PACKED_INT32_ARRAY: {
		"pack": func(value: PackedInt32Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var buffer = value.to_byte_array()
			_put_dynamic_int(buffer.size(), stream)
			stream.put_data(buffer)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedInt32Array:
			return PackedByteArray(stream.get_data(_get_dynamic_int(stream))[1]).to_int32_array(),
	},
	TYPE_PACKED_INT64_ARRAY: {
		"pack": func(value: PackedInt64Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var buffer = value.to_byte_array()
			_put_dynamic_int(buffer.size(), stream)
			stream.put_data(buffer)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedInt64Array:
			return PackedByteArray(stream.get_data(_get_dynamic_int(stream))[1]).to_int64_array(),
	},
	TYPE_PACKED_FLOAT32_ARRAY: {
		"pack": func(value: PackedFloat32Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var buffer = value.to_byte_array()
			_put_dynamic_int(buffer.size(), stream)
			stream.put_data(buffer)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedFloat32Array:
			return PackedByteArray(stream.get_data(_get_dynamic_int(stream))[1]).to_float32_array(),
	},
	TYPE_PACKED_FLOAT64_ARRAY: {
		"pack": func(value: PackedFloat64Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var buffer = value.to_byte_array()
			_put_dynamic_int(buffer.size(), stream)
			stream.put_data(buffer)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedFloat64Array:
			return PackedByteArray(stream.get_data(_get_dynamic_int(stream))[1]).to_float64_array(),
	},
	TYPE_PACKED_STRING_ARRAY: {
		"pack": func(value: PackedStringArray, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			_put_dynamic_int(value.size(), stream)
			for string in value:
				pack(string, stream, TYPE_STRING)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedStringArray:
			var array_size = _get_dynamic_int(stream)
			var array := PackedStringArray()
			for i in array_size:
				array.append(unpack(stream, TYPE_STRING))
			return array,
	},
	TYPE_PACKED_VECTOR2_ARRAY: {
		"pack": func(value: PackedVector2Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			_put_dynamic_int(value.size(), stream)
			for vector in value:
				pack(vector, stream, TYPE_VECTOR2)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedVector2Array:
			var array_size = _get_dynamic_int(stream)
			var array := PackedVector2Array()
			for i in array_size:
				array.append(unpack(stream, TYPE_VECTOR2))
			return array,
	},
	TYPE_PACKED_VECTOR3_ARRAY: {
		"pack": func(value: PackedVector3Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			_put_dynamic_int(value.size(), stream)
			for vector in value:
				pack(vector, stream, TYPE_VECTOR3)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedVector3Array:
			var array_size = _get_dynamic_int(stream)
			var array := PackedVector3Array()
			for i in array_size:
				array.append(unpack(stream, TYPE_VECTOR3))
			return array,
	},
	TYPE_PACKED_VECTOR4_ARRAY: {
		"pack": func(value: PackedVector4Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			_put_dynamic_int(value.size(), stream)
			for vector in value:
				pack(vector, stream, TYPE_VECTOR4)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedVector4Array:
			var array_size = _get_dynamic_int(stream)
			var array := PackedVector4Array()
			for i in array_size:
				array.append(unpack(stream, TYPE_VECTOR4))
			return array,
	},
	TYPE_PACKED_COLOR_ARRAY: {
		"pack": func(value: PackedColorArray, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			_put_dynamic_int(value.size(), stream)
			for vector in value:
				pack(vector, stream, TYPE_COLOR)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedColorArray:
			var array_size = _get_dynamic_int(stream)
			var array := PackedColorArray()
			for i in array_size:
				array.append(unpack(stream, TYPE_COLOR))
			return array,
	},
	CustomTypes.TYPED_ARRAY: {
		"pack": func(array: Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var item_type: int = typeof(array[0]) if array.size() > 0 else TYPE_NIL
			_put_dynamic_int(array.size(), stream)
			stream.put_u8(item_type)
			for item in array:
				pack(item, stream, item_type)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Array:
			var array_size = _get_dynamic_int(stream)
			var item_type = stream.get_u8()
			var array = []
			for i in array_size:
				array.append(unpack(stream, item_type))
			return array,
	}
}

static func pack_to_bytes(value) -> PackedByteArray:
	return pack(value).data_array

static func unpack_from_bytes(bytes: PackedByteArray):
	var stream := StreamPeerBuffer.new()
	stream.data_array = bytes
	return unpack(stream)

static func pack(value, stream := StreamPeerBuffer.new(), type := -1, add_type_prefix := false) -> StreamPeerBuffer:
	add_type_prefix = add_type_prefix or type == -1

	if type == -1:
		type = typeof(value)

	if type == TYPE_ARRAY and _can_array_be_typed(value):
		type = CustomTypes.TYPED_ARRAY
	if type == TYPE_INT:
		type = _get_int_type(value)
	if type == TYPE_OBJECT and value == null:
		type = TYPE_NIL

	if not type in _serializer:
		push_error("[Seriously] Unknown type: ", type)
		return stream

	if add_type_prefix:
		stream.put_u8(type)

	return _serializer[type].pack.call(value, stream)

static func unpack(stream: StreamPeerBuffer, type := -1):
	if type == -1:
		type = stream.get_u8()

	if not type in _serializer:
		push_error("[Seriously] Unknown type: ", type)
		return null

	return _serializer[type].unpack.call(stream)

#region private methods
static func _put_dynamic_int(value: int, stream: StreamPeerBuffer):
	while true:
		var b = value & 0x7F
		value >>= 7
		if value > 0:
			stream.put_u8(b | 0x80)
		else:
			stream.put_u8(b)
			break

static func _get_dynamic_int(stream: StreamPeerBuffer) -> int:
	var result = 0
	var shift = 0
	while true:
		var b = stream.get_u8()
		result |= (b & 0x7F) << shift
		if (b & 0x80) == 0:
			break
		shift += 7
	return result

static func _can_array_be_typed(array: Array) -> bool:
	if array.is_typed():
		return true
	if array.size() <= 1: 
		return false

	var array_type: int = typeof(array[0])
	for entry in array:
		if typeof(entry) != array_type: 
			return false 

	return true

static func _get_int_type(value: int) -> int:
	if value >= 0:
		if value <= 255: return CustomTypes.UINT8
		if value <= 65535: return CustomTypes.UINT16
		if value <= 4294967295: return CustomTypes.UINT32
		return CustomTypes.UINT64
	else:
		if value >= -128: return CustomTypes.INT8
		if value >= -32768: return CustomTypes.INT16
		if value >= -2147483648: return CustomTypes.INT32
		return CustomTypes.INT64
#endregion
