const Constants = preload("./Constants.gd")
const TYPES = Constants.TYPES
const Unpacker = {}
const Packer = {}

#########################
## Constructor and API ##
#########################
func _init():
	for type_key in TYPES:
		var pack_key = type_key + "_pack"
		var unpack_key = type_key + "_unpack"

		if has_method(pack_key):
			Packer[type_key] = funcref(self, pack_key)
			Packer[TYPES[type_key]] = funcref(self, pack_key)
		if has_method(unpack_key):
			Unpacker[type_key] = funcref(self, unpack_key)
			Unpacker[TYPES[type_key]] = funcref(self, unpack_key)

func pack(value, stream: StreamPeerBuffer = null, add_type := true) -> StreamPeerBuffer:
	return pack_type(typeof(value), value, stream, add_type)

func unpack(stream: StreamPeerBuffer = null):
	return unpack_type(stream.get_u8(), stream)

func pack_type(type: int, value, stream: StreamPeerBuffer = null, add_type := true) -> StreamPeerBuffer:
	if not type in Packer: return null
	Packer[type].call_func(value, stream, add_type)
	return stream

func unpack_type(type: int, stream: StreamPeerBuffer):
	if not type in Unpacker: return null
	return Unpacker[type].call_func(stream)

##########################
## Type Packer/Unpacker ##
##########################

# Null
func TYPE_NIL_pack(value, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_NIL)
	return
func TYPE_NIL_unpack(stream):
	return null

# Bool
func TYPE_BOOL_pack(value: bool, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_BOOL)
	stream.put_u8(1 if value else 0)
func TYPE_BOOL_unpack(stream: StreamPeerBuffer) -> bool:
	return stream.get_u8() > 0

# Int
func TYPE_INT_pack(value: int, stream: StreamPeerBuffer, add_type := true):
	var unsigned = value >= 0
	var bit_size = 8
	if value >= -0xFF && value <= 0xFF: bit_size = 8
	elif value >= -0xFFFF && value <= 0xFFFF: bit_size = 16
	else: bit_size = 32
	var int_type = TYPES["TYPE_%sINT%s" % ["U" if unsigned else "", bit_size]]
	return pack_type(int_type, value, stream, add_type)
func TYPE_INT_unpack(stream: StreamPeerBuffer):
	print_debug("TYPE_INT type unpack requested. This is not possible!")
	return null

# Int8
func TYPE_UINT8_pack(value: int, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_UINT8)
	stream.put_u8(value)
func TYPE_UINT8_unpack(stream: StreamPeerBuffer) -> int:
	return stream.get_u8()

func TYPE_INT8_pack(value: int, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_INT8)
	stream.put_8(value)
func TYPE_INT8_unpack(stream: StreamPeerBuffer) -> int:
	return stream.get_8()

# Int16
func TYPE_UINT16_pack(value: int, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_UINT16)
	stream.put_u16(value)
func TYPE_UINT16_unpack(stream: StreamPeerBuffer) -> int:
	return stream.get_u16()

func TYPE_INT16_pack(value: int, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_INT16)
	stream.put_16(value)
func TYPE_INT16_unpack(stream: StreamPeerBuffer) -> int:
	return stream.get_16()

# Int32
func TYPE_UINT32_pack(value: int, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_UINT32)
	stream.put_u32(value)
func TYPE_UINT32_unpack(stream: StreamPeerBuffer) -> int:
	return stream.get_u32()

func TYPE_INT32_pack(value: int, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_INT32)
	stream.put_32(value)
func TYPE_INT32_unpack(stream: StreamPeerBuffer) -> int:
	return stream.get_32()

# Float
func TYPE_REAL_pack(value: float, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_REAL)
	stream.put_float(value)
func TYPE_REAL_unpack(stream: StreamPeerBuffer) -> float:
	return stream.get_float()

# String
func TYPE_STRING_pack(value: String, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_STRING)
	# TODO: Find a better solution to parse strings. While this works, causes alot of overhead.
	stream.put_utf8_string(value)
func TYPE_STRING_unpack(stream: StreamPeerBuffer) -> String:
	return stream.get_utf8_string()

# Rect2
func TYPE_RECT2_pack(value: Rect2, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_RECT2)
	stream.put_float(value.position.x)
	stream.put_float(value.position.y)
	stream.put_float(value.size.x)
	stream.put_float(value.size.y)
func TYPE_RECT2_unpack(stream: StreamPeerBuffer) -> Rect2:
	return Rect2(stream.get_float(), stream.get_float(), stream.get_float(), stream.get_float())

# Vector2
func TYPE_VECTOR2_pack(value: Vector2, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_VECTOR2)
	stream.put_float(value.x)
	stream.put_float(value.y)
func TYPE_VECTOR2_unpack(stream: StreamPeerBuffer) -> Vector2:
	return Vector2(stream.get_float(), stream.get_float())

# Vector3
func TYPE_VECTOR3_pack(value: Vector3, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_VECTOR3)
	stream.put_float(value.x)
	stream.put_float(value.y)
	stream.put_float(value.z)
func TYPE_VECTOR3_unpack(stream: StreamPeerBuffer) -> Vector3:
	return Vector3(stream.get_float(), stream.get_float(), stream.get_float())

# Transform2D
func TYPE_TRANSFORM2D_pack(value: Transform2D, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_TRANSFORM2D)
	TYPE_VECTOR2_pack(value.x, stream, false)
	TYPE_VECTOR2_pack(value.y, stream, false)
	TYPE_VECTOR2_pack(value.origin, stream, false)
func TYPE_TRANSFORM2D_unpack(stream: StreamPeerBuffer) -> Transform2D:
	return Transform2D(TYPE_VECTOR2_unpack(stream), TYPE_VECTOR2_unpack(stream), TYPE_VECTOR2_unpack(stream))

# Plane
func TYPE_PLANE_pack(value: Plane, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_PLANE)
	TYPE_VECTOR3_pack(value.normal, stream, false)
	stream.put_float(value.d)
func TYPE_PLANE_unpack(stream: StreamPeerBuffer) -> Plane:
	return Plane(TYPE_VECTOR3_unpack(stream), stream.get_float())

# Quat
func TYPE_QUAT_pack(value: Quat, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_QUAT)
	stream.put_float(value.x)
	stream.put_float(value.y)
	stream.put_float(value.z)
	stream.put_float(value.w)
func TYPE_QUAT_unpack(stream: StreamPeerBuffer) -> Quat:
	return Quat(stream.get_float(), stream.get_float(), stream.get_float(), stream.get_float())

# AABB
func TYPE_AABB_pack(value: AABB, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_AABB)
	TYPE_VECTOR3_pack(value.position, stream, false)
	TYPE_VECTOR3_pack(value.size, stream, false)
func TYPE_AABB_unpack(stream: StreamPeerBuffer) -> AABB:
	return AABB(TYPE_VECTOR3_unpack(stream), TYPE_VECTOR3_unpack(stream))

# Basis
func TYPE_BASIS_pack(value: Basis, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_BASIS)
	TYPE_VECTOR3_pack(value.x, stream, false)
	TYPE_VECTOR3_pack(value.y, stream, false)
	TYPE_VECTOR3_pack(value.z, stream, false)
func TYPE_BASIS_unpack(stream: StreamPeerBuffer) -> Basis:
	return Basis(TYPE_VECTOR3_unpack(stream), TYPE_VECTOR3_unpack(stream), TYPE_VECTOR3_unpack(stream))

# Transform
func TYPE_TRANSFORM_pack(value: Transform, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_TRANSFORM)
	TYPE_BASIS_pack(value.basis, stream, false)
	TYPE_VECTOR3_pack(value.origin, stream, false)
func TYPE_TRANSFORM_unpack(stream: StreamPeerBuffer) -> Transform:
	return Transform(TYPE_BASIS_unpack(stream), TYPE_VECTOR3_unpack(stream))

# Color
func TYPE_COLOR_pack(value: Color, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_COLOR)
	stream.put_u32(value.to_rgba32())
func TYPE_COLOR_unpack(stream: StreamPeerBuffer) -> Color:
	return Color(stream.get_u32())

# NodePath
func TYPE_NODE_PATH_pack(value: NodePath, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_NODE_PATH)
	TYPE_STRING_pack(str(value), stream, false)
func TYPE_NODE_PATH_unpack(stream: StreamPeerBuffer) -> NodePath:
	return NodePath(TYPE_STRING_unpack(stream))

# RID
func TYPE_RID_pack(value: RID, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_RID)
func TYPE_RID_unpack(stream: StreamPeerBuffer) -> RID:
	return RID()

# Object
func TYPE_OBJECT_pack(value: Object, stream: StreamPeerBuffer, add_type := true):
	if add_type:
		if value == null: stream.put_u8(TYPES.TYPE_NIL)
		else: stream.put_u8(TYPES.TYPE_OBJECT)
	if value == null: return
	var property_list = value.get_property_list()
	stream.put_u16(property_list.size() - 3)
	for property in property_list:
		if property.name == "Reference" || property.name == "script" || property.name == "Script Variables": continue
		TYPE_STRING_pack(property.name, stream, false)
		pack(value.get(property.name), stream)
func TYPE_OBJECT_unpack(stream: StreamPeerBuffer):
	var object_size = stream.get_u16()
	var object = {}
	for j in object_size:
		object[TYPE_STRING_unpack(stream)] = unpack(stream)
	return object

# Dictionary
func TYPE_DICTIONARY_pack(value: Dictionary, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_DICTIONARY)
	stream.put_u16(value.size())
	for key in value.keys():
		TYPE_STRING_pack(key, stream, false)
		pack(value[key], stream)
func TYPE_DICTIONARY_unpack(stream: StreamPeerBuffer) -> Dictionary:
	var dictionary_size = stream.get_u16()
	var dictionary = {}
	for j in dictionary_size:
		dictionary[TYPE_STRING_unpack(stream)] = unpack(stream)
	return dictionary

# Array
func TYPE_ARRAY_pack(value: Array, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_ARRAY)
	var array_size := value.size()
	stream.put_u16(array_size)
	for i in array_size:
		pack(value[i], stream)
func TYPE_ARRAY_unpack(stream: StreamPeerBuffer) -> Array:
	var array_size = stream.get_u16()
	var array = Array()
	for i in array_size:
		array.push_back(unpack(stream))
	return array

# Raw array
func TYPE_RAW_ARRAY_pack(value: PoolByteArray, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_RAW_ARRAY)
	stream.put_u16(value.size())
	stream.put_data(value)
func TYPE_RAW_ARRAY_unpack(stream: StreamPeerBuffer) -> PoolByteArray:
	return PoolByteArray(stream.get_data(stream.get_u16()))

# Int array
func TYPE_INT_ARRAY_pack(value: PoolIntArray, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_TYPED_ARRAY)
	var array_size = value.size()
	stream.put_u16(array_size)

	var unsigned = true
	var bit_size = 8

	for num in value:
		if unsigned == true && num < 0: unsigned = false
		if bit_size >= 32: continue # We already know we have the biggest size
		if num > -0xFF && num < 0xFF && bit_size < 8: bit_size = 8
		elif num > -0xFFFF && num < 0xFFFF && bit_size < 16: bit_size = 16
		else: bit_size = 32

	var int_type = TYPES["TYPE_%sINT%s" % ["U" if unsigned else "", bit_size]]
	var setter_function_name = "put_%s%s" % ["u" if unsigned else "", bit_size]
	stream.put_u8(int_type)

	for num in value:
		stream.call(setter_function_name, num)
func TYPE_INT_ARRAY_unpack(stream: StreamPeerBuffer):
	print_debug("TYPE_INT_ARRAY type unpack requested. This is not possible!")
	return null

# Float array
func TYPE_REAL_ARRAY_pack(value: PoolRealArray, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_TYPED_ARRAY)
	var array_size = value.size()
	stream.put_u16(array_size)
	stream.put_u8(TYPES.TYPE_REAL)
	for num in value:
		stream.set_float(num)
func TYPE_REAL_ARRAY_unpack(stream: StreamPeerBuffer):
	print_debug("TYPE_REAL_ARRAY type unpack requested. This is not possible!")
	return null

# String array
func TYPE_STRING_ARRAY_pack(value: PoolStringArray, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_TYPED_ARRAY)
	var array_size = value.size()
	stream.put_u16(array_size)
	stream.put_u8(TYPES.TYPE_STRING)
	for string in value:
		TYPE_STRING_pack(string, stream, false)
func TYPE_STRING_ARRAY_unpack(stream: StreamPeerBuffer):
	print_debug("TYPE_STRING_ARRAY type unpack requested. This is not possible!")
	return null

# Vector2 Array
func TYPE_VECTOR2_ARRAY_pack(value: PoolVector2Array, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_TYPED_ARRAY)
	var array_size = value.size()
	stream.put_u16(array_size)
	stream.put_u8(TYPES.TYPE_VECTOR2)
	for vector2 in value:
		TYPE_VECTOR2_pack(vector2, stream, false)
func TYPE_VECTOR2_ARRAY_unpack(stream: StreamPeerBuffer):
	print_debug("TYPE_VECTOR2_ARRAY type unpack requested. This is not possible!")
	return null

# Vector3 Array
func TYPE_VECTOR3_ARRAY_pack(value: PoolVector3Array, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_TYPED_ARRAY)
	var array_size = value.size()
	stream.put_u16(array_size)
	stream.put_u8(TYPES.TYPE_VECTOR3)
	for vector3 in value:
		TYPE_VECTOR3_pack(vector3, stream, false)
func TYPE_VECTOR3_ARRAY_unpack(stream: StreamPeerBuffer):
	print_debug("TYPE_VECTOR3_ARRAY type unpack requested. This is not possible!")
	return null

# Color array
func TYPE_COLOR_ARRAY_pack(value: PoolColorArray, stream: StreamPeerBuffer, add_type := true):
	if add_type: stream.put_u8(TYPES.TYPE_TYPED_ARRAY)
	var array_size = value.size()
	stream.put_u16(array_size)
	stream.put_u8(TYPES.TYPE_COLOR)
	for color in value:
		TYPE_COLOR_pack(color, stream, false)
func TYPE_COLOR_ARRAY_unpack(stream: StreamPeerBuffer):
	print_debug("TYPE_COLOR_ARRAY type unpack requested. This is not possible!")
	return null

# Typed array
func TYPE_TYPED_ARRAY_pack(value: Array, stream: StreamPeerBuffer, add_type := true):
	print_debug("TYPE_TYPED_ARRAY type pack requested. This is not possible!")
	return null
func TYPE_TYPED_ARRAY_unpack(stream: StreamPeerBuffer):
	var array_size = stream.get_u16()
	var array_type = stream.get_u8()
	if not array_type in Unpacker: return null
	var unpacker = Unpacker[array_type]
	var array = Array()
	for i in array_size:
		array.push_back(unpacker.call_funcv(stream))
	return array
