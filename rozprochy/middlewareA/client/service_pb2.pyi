from google.protobuf.internal import containers as _containers
from google.protobuf.internal import enum_type_wrapper as _enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Iterable as _Iterable, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class MeterType(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    THERMOMETER: _ClassVar[MeterType]
    CO_METER: _ClassVar[MeterType]
    BAROMETER: _ClassVar[MeterType]

class CO_danger(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    SAFE: _ClassVar[CO_danger]
    WARNING: _ClassVar[CO_danger]
    DANGEROUS: _ClassVar[CO_danger]

class DeviceType(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    METER: _ClassVar[DeviceType]
    HEATER: _ClassVar[DeviceType]
    SECURITY: _ClassVar[DeviceType]

class WorkingState(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    ON: _ClassVar[WorkingState]
    OFF: _ClassVar[WorkingState]
    STARTING: _ClassVar[WorkingState]
    STOPPING: _ClassVar[WorkingState]
THERMOMETER: MeterType
CO_METER: MeterType
BAROMETER: MeterType
SAFE: CO_danger
WARNING: CO_danger
DANGEROUS: CO_danger
METER: DeviceType
HEATER: DeviceType
SECURITY: DeviceType
ON: WorkingState
OFF: WorkingState
STARTING: WorkingState
STOPPING: WorkingState

class Empty(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class SimpleResponse(_message.Message):
    __slots__ = ("status",)
    STATUS_FIELD_NUMBER: _ClassVar[int]
    status: int
    def __init__(self, status: _Optional[int] = ...) -> None: ...

class Temperature(_message.Message):
    __slots__ = ("value",)
    VALUE_FIELD_NUMBER: _ClassVar[int]
    value: float
    def __init__(self, value: _Optional[float] = ...) -> None: ...

class CO_level(_message.Message):
    __slots__ = ("level", "danger")
    LEVEL_FIELD_NUMBER: _ClassVar[int]
    DANGER_FIELD_NUMBER: _ClassVar[int]
    level: float
    danger: CO_danger
    def __init__(self, level: _Optional[float] = ..., danger: _Optional[_Union[CO_danger, str]] = ...) -> None: ...

class Pressure(_message.Message):
    __slots__ = ("pressure",)
    PRESSURE_FIELD_NUMBER: _ClassVar[int]
    pressure: float
    def __init__(self, pressure: _Optional[float] = ...) -> None: ...

class Meter(_message.Message):
    __slots__ = ("type",)
    TYPE_FIELD_NUMBER: _ClassVar[int]
    type: MeterType
    def __init__(self, type: _Optional[_Union[MeterType, str]] = ...) -> None: ...

class MeterState(_message.Message):
    __slots__ = ("meter_type", "temperature", "co_level", "pressure")
    METER_TYPE_FIELD_NUMBER: _ClassVar[int]
    TEMPERATURE_FIELD_NUMBER: _ClassVar[int]
    CO_LEVEL_FIELD_NUMBER: _ClassVar[int]
    PRESSURE_FIELD_NUMBER: _ClassVar[int]
    meter_type: MeterType
    temperature: Temperature
    co_level: CO_level
    pressure: Pressure
    def __init__(self, meter_type: _Optional[_Union[MeterType, str]] = ..., temperature: _Optional[_Union[Temperature, _Mapping]] = ..., co_level: _Optional[_Union[CO_level, _Mapping]] = ..., pressure: _Optional[_Union[Pressure, _Mapping]] = ...) -> None: ...

class Heater(_message.Message):
    __slots__ = ("max_temp", "min_temp", "power")
    MAX_TEMP_FIELD_NUMBER: _ClassVar[int]
    MIN_TEMP_FIELD_NUMBER: _ClassVar[int]
    POWER_FIELD_NUMBER: _ClassVar[int]
    max_temp: float
    min_temp: float
    power: int
    def __init__(self, max_temp: _Optional[float] = ..., min_temp: _Optional[float] = ..., power: _Optional[int] = ...) -> None: ...

class HeaterState(_message.Message):
    __slots__ = ("current_temp", "set_temp", "current_power")
    CURRENT_TEMP_FIELD_NUMBER: _ClassVar[int]
    SET_TEMP_FIELD_NUMBER: _ClassVar[int]
    CURRENT_POWER_FIELD_NUMBER: _ClassVar[int]
    current_temp: float
    set_temp: float
    current_power: int
    def __init__(self, current_temp: _Optional[float] = ..., set_temp: _Optional[float] = ..., current_power: _Optional[int] = ...) -> None: ...

class SecurityDevice(_message.Message):
    __slots__ = ("width", "height")
    WIDTH_FIELD_NUMBER: _ClassVar[int]
    HEIGHT_FIELD_NUMBER: _ClassVar[int]
    width: int
    height: int
    def __init__(self, width: _Optional[int] = ..., height: _Optional[int] = ...) -> None: ...

class SecurityState(_message.Message):
    __slots__ = ("movement_detected", "tampered", "night_vision")
    MOVEMENT_DETECTED_FIELD_NUMBER: _ClassVar[int]
    TAMPERED_FIELD_NUMBER: _ClassVar[int]
    NIGHT_VISION_FIELD_NUMBER: _ClassVar[int]
    movement_detected: bool
    tampered: bool
    night_vision: bool
    def __init__(self, movement_detected: bool = ..., tampered: bool = ..., night_vision: bool = ...) -> None: ...

class Id(_message.Message):
    __slots__ = ("id",)
    ID_FIELD_NUMBER: _ClassVar[int]
    id: int
    def __init__(self, id: _Optional[int] = ...) -> None: ...

class DeviceInfo(_message.Message):
    __slots__ = ("type", "id", "name", "meter", "heater", "security")
    TYPE_FIELD_NUMBER: _ClassVar[int]
    ID_FIELD_NUMBER: _ClassVar[int]
    NAME_FIELD_NUMBER: _ClassVar[int]
    METER_FIELD_NUMBER: _ClassVar[int]
    HEATER_FIELD_NUMBER: _ClassVar[int]
    SECURITY_FIELD_NUMBER: _ClassVar[int]
    type: DeviceType
    id: Id
    name: str
    meter: Meter
    heater: Heater
    security: SecurityDevice
    def __init__(self, type: _Optional[_Union[DeviceType, str]] = ..., id: _Optional[_Union[Id, _Mapping]] = ..., name: _Optional[str] = ..., meter: _Optional[_Union[Meter, _Mapping]] = ..., heater: _Optional[_Union[Heater, _Mapping]] = ..., security: _Optional[_Union[SecurityDevice, _Mapping]] = ...) -> None: ...

class DevicesInfo(_message.Message):
    __slots__ = ("devices",)
    DEVICES_FIELD_NUMBER: _ClassVar[int]
    devices: _containers.RepeatedCompositeFieldContainer[DeviceInfo]
    def __init__(self, devices: _Optional[_Iterable[_Union[DeviceInfo, _Mapping]]] = ...) -> None: ...

class DeviceState(_message.Message):
    __slots__ = ("working_state", "meter_state", "heater_state", "security_state", "is_ok")
    WORKING_STATE_FIELD_NUMBER: _ClassVar[int]
    METER_STATE_FIELD_NUMBER: _ClassVar[int]
    HEATER_STATE_FIELD_NUMBER: _ClassVar[int]
    SECURITY_STATE_FIELD_NUMBER: _ClassVar[int]
    IS_OK_FIELD_NUMBER: _ClassVar[int]
    working_state: WorkingState
    meter_state: MeterState
    heater_state: HeaterState
    security_state: SecurityState
    is_ok: bool
    def __init__(self, working_state: _Optional[_Union[WorkingState, str]] = ..., meter_state: _Optional[_Union[MeterState, _Mapping]] = ..., heater_state: _Optional[_Union[HeaterState, _Mapping]] = ..., security_state: _Optional[_Union[SecurityState, _Mapping]] = ..., is_ok: bool = ...) -> None: ...

class DevInfoResponse(_message.Message):
    __slots__ = ("status", "devices")
    STATUS_FIELD_NUMBER: _ClassVar[int]
    DEVICES_FIELD_NUMBER: _ClassVar[int]
    status: int
    devices: DevicesInfo
    def __init__(self, status: _Optional[int] = ..., devices: _Optional[_Union[DevicesInfo, _Mapping]] = ...) -> None: ...

class DevStateResponse(_message.Message):
    __slots__ = ("status", "state")
    STATUS_FIELD_NUMBER: _ClassVar[int]
    STATE_FIELD_NUMBER: _ClassVar[int]
    status: int
    state: DeviceState
    def __init__(self, status: _Optional[int] = ..., state: _Optional[_Union[DeviceState, _Mapping]] = ...) -> None: ...

class TempInfo(_message.Message):
    __slots__ = ("id", "new_temp")
    ID_FIELD_NUMBER: _ClassVar[int]
    NEW_TEMP_FIELD_NUMBER: _ClassVar[int]
    id: Id
    new_temp: float
    def __init__(self, id: _Optional[_Union[Id, _Mapping]] = ..., new_temp: _Optional[float] = ...) -> None: ...

class PowerInfo(_message.Message):
    __slots__ = ("id", "new_power")
    ID_FIELD_NUMBER: _ClassVar[int]
    NEW_POWER_FIELD_NUMBER: _ClassVar[int]
    id: Id
    new_power: int
    def __init__(self, id: _Optional[_Union[Id, _Mapping]] = ..., new_power: _Optional[int] = ...) -> None: ...
