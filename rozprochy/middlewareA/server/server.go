package main

import (
	"context"
	pb "server/common"
)

type deviceRegistryServer struct {
	pb.UnimplementedDeviceRegistryServer
}

func (server *deviceRegistryServer) GetDevices(
	_ context.Context,
	_ *pb.Empty,
) (*pb.DevInfoResponse, error) {
	response := new(pb.DevInfoResponse)
	response.Devices = new(pb.DevicesInfo)
	response.Devices.Devices = DEVICE_INFOS
	response.Status = new(uint64)
	*response.Status = 0
	return response, nil
}

func (server *deviceRegistryServer) GetDeviceState(
	_ context.Context,
	id *pb.Id,
) (*pb.DevStateResponse, error) {
	response := new(pb.DevStateResponse)
	response.Status = new(uint64)
	*response.Status = 0
	response.State = DEVICE_STATES[*id.Id]
	return response, nil
}

func (server *deviceRegistryServer) ToggleDevice(
	_ context.Context,
	id *pb.Id,
) (*pb.SimpleResponse, error) {
	device_state := DEVICE_STATES[*id.Id]
	working_state := *device_state.WorkingState
	switch working_state {
	case pb.WorkingState_ON:
		fallthrough
	case pb.WorkingState_STARTING:
		*device_state.WorkingState = pb.WorkingState_STOPPING
	case pb.WorkingState_OFF:
		fallthrough
	case pb.WorkingState_STOPPING:
		*device_state.WorkingState = pb.WorkingState_STARTING
	}

	response := new(pb.SimpleResponse)
	response.Status = new(uint64)
	*response.Status = 0
	return response, nil
}

type heaterControllerServer struct {
	pb.UnimplementedHeaterControllerServer
}

func (server *heaterControllerServer) SetTemp(
	_ context.Context,
	info *pb.TempInfo,
) (*pb.SimpleResponse, error) {
	response := new(pb.SimpleResponse)
	response.Status = new(uint64)
	id := *info.Id.Id
	devinfo := DEVICE_INFOS[id]

	if *devinfo.Type == pb.DeviceType_HEATER {
		heater_info := devinfo.TypeInfo.(*pb.DeviceInfo_Heater)
		target_temp := *info.NewTemp
		if target_temp < *heater_info.Heater.MinTemp {
			*response.Status = 2
		} else if target_temp > *heater_info.Heater.MaxTemp {
			*response.Status = 3
		} else {
			heater_state := DEVICE_STATES[id].TypeState.(*pb.DeviceState_HeaterState)
			*heater_state.HeaterState.SetTemp = target_temp
			*response.Status = 0
		}
	} else {
		*response.Status = 1
	}

	return response, nil
}

func (server *heaterControllerServer) SetPower(
	_ context.Context,
	info *pb.PowerInfo,
) (*pb.SimpleResponse, error) {
	response := new(pb.SimpleResponse)
	response.Status = new(uint64)
	id := *info.Id.Id
	devinfo := DEVICE_INFOS[id]

	if *devinfo.Type == pb.DeviceType_HEATER {
		heater_info := devinfo.TypeInfo.(*pb.DeviceInfo_Heater)
		target_power := *info.NewPower
		if target_power > *heater_info.Heater.Power {
			*response.Status = 2
		} else {
			heater_state := DEVICE_STATES[id].TypeState.(*pb.DeviceState_HeaterState)
			*heater_state.HeaterState.CurrentPower = target_power
			*response.Status = 0
		}
	} else {
		*response.Status = 1
	}

	return response, nil
}

type securityControllerServer struct {
	pb.UnimplementedSecurityControllerServer
}

func (server *securityControllerServer) ToggleNightVision(
	_ context.Context,
	id *pb.Id,
) (*pb.SimpleResponse, error) {
	response := new(pb.SimpleResponse)
	response.Status = new(uint64)
	did := *id.Id
	devinfo := DEVICE_INFOS[did]

	if *devinfo.Type == pb.DeviceType_SECURITY {
		security_state := DEVICE_STATES[did].TypeState.(*pb.DeviceState_SecurityState)
		*security_state.SecurityState.NightVision =
			!*security_state.SecurityState.NightVision
		*response.Status = 0
	} else {
		*response.Status = 1
	}

	return response, nil
}
