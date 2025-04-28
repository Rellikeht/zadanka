package main

import (
	"fmt"
	"log"
	"math"
	"math/rand"
	"net"
	pb "server/common"
	"time"

	"google.golang.org/grpc"
)

const (
	DEVICE_AMOUNT    = 8
	MAX_HEATER_POWER = 10000
	MIN_HEATER_POWER = 1000
)

var (
	DEVICE_INFOS  = []*pb.DeviceInfo{}
	DEVICE_STATES = []*pb.DeviceState{}
	RESOLUTIONS   = [...][2]uint64{{1920, 1080}, {1280, 720}}
)

func beautify_number[Ftype float32 | float64](num *Ftype) {
	*num -= Ftype(math.Mod(float64(*num), 0.1))
}

func addRandomDevice() {
	device_info := new(pb.DeviceInfo)
	device_info.Id = new(pb.Id)
	device_info.Id.Id = new(uint64)
	*device_info.Id.Id = uint64(len(DEVICE_INFOS))
	device_info.Type = new(pb.DeviceType)
	*device_info.Type = pb.DeviceType(rand.Int() % 3)
	name := fmt.Sprintf("Urządzenie %d", len(DEVICE_INFOS))
	device_info.Name = &name

	device_state := new(pb.DeviceState)
	device_state.IsOk = new(bool)
	*device_state.IsOk = true
	device_state.WorkingState = new(pb.WorkingState)
	*device_state.WorkingState = pb.WorkingState(rand.Int() % 4)

	switch *device_info.Type {
	case pb.DeviceType_METER:
		meter_info := new(pb.DeviceInfo_Meter)
		meter_info.Meter = new(pb.Meter)
		meter_info.Meter.Type = new(pb.MeterType)
		*meter_info.Meter.Type = pb.MeterType(rand.Int() % 3)
		device_info.TypeInfo = meter_info

		meter_state := new(pb.DeviceState_MeterState)
		meter_state.MeterState = new(pb.MeterState)
		meter_state.MeterState.MeterType = meter_info.Meter.Type
		switch *meter_state.MeterState.MeterType {
		case pb.MeterType_BAROMETER:
			pressure := new(pb.MeterState_Pressure)
			pressure.Pressure = new(pb.Pressure)
			pressure.Pressure.Pressure = new(float64)
			*pressure.Pressure.Pressure = rand.Float64()*100 + 950
			beautify_number(pressure.Pressure.Pressure)
			meter_state.MeterState.Value = pressure
		case pb.MeterType_CO_METER:
			level := new(pb.MeterState_CoLevel)
			level.CoLevel = new(pb.COLevel)
			level.CoLevel.Level = new(float64)
			*level.CoLevel.Level = rand.Float64() * 5
			beautify_number(level.CoLevel.Level)
			// TODO danger
			meter_state.MeterState.Value = level
		case pb.MeterType_THERMOMETER:
			temperature := new(pb.MeterState_Temperature)
			temperature.Temperature = new(pb.Temperature)
			temperature.Temperature.Value = new(float64)
			*temperature.Temperature.Value = rand.Float64()*30 + 10
			beautify_number(temperature.Temperature.Value)
			meter_state.MeterState.Value = temperature

		}
		device_state.TypeState = meter_state

	case pb.DeviceType_HEATER:
		heater_info := new(pb.DeviceInfo_Heater)
		heater_info.Heater = new(pb.Heater)
		heater_info.Heater.Power = new(uint64)
		*heater_info.Heater.Power =
			rand.Uint64()%(MAX_HEATER_POWER-MIN_HEATER_POWER) + MIN_HEATER_POWER
		heater_info.Heater.MinTemp = new(float64)
		*heater_info.Heater.MinTemp = rand.Float64() * 5
		beautify_number(heater_info.Heater.MinTemp)
		heater_info.Heater.MaxTemp = new(float64)
		*heater_info.Heater.MaxTemp = rand.Float64()*20 + 30
		beautify_number(heater_info.Heater.MaxTemp)
		device_info.TypeInfo = heater_info

		heater_state := new(pb.DeviceState_HeaterState)
		heater_state.HeaterState = new(pb.HeaterState)
		heater_state.HeaterState.CurrentTemp = new(float64)
		*heater_state.HeaterState.CurrentTemp =
			rand.Float64()*
				(*heater_info.Heater.MaxTemp-*heater_info.Heater.MinTemp) +
				*heater_info.Heater.MinTemp
		beautify_number(heater_state.HeaterState.CurrentTemp)
		heater_state.HeaterState.SetTemp = new(float64)
		*heater_state.HeaterState.SetTemp =
			rand.Float64()*
				(*heater_info.Heater.MaxTemp-*heater_info.Heater.MinTemp) +
				*heater_info.Heater.MinTemp
		beautify_number(heater_state.HeaterState.SetTemp)
		heater_state.HeaterState.CurrentPower = new(uint64)
		*heater_state.HeaterState.CurrentPower =
			rand.Uint64() % *heater_info.Heater.Power
		device_state.TypeState = heater_state

	case pb.DeviceType_SECURITY:
		security_info := new(pb.DeviceInfo_Security)
		security_info.Security = new(pb.SecurityDevice)
		security_info.Security.Width = new(uint64)
		security_info.Security.Height = new(uint64)
		res := rand.Int() % len(RESOLUTIONS)
		*security_info.Security.Width = RESOLUTIONS[res][0]
		*security_info.Security.Height = RESOLUTIONS[res][1]
		device_info.TypeInfo = security_info

		security_state := new(pb.DeviceState_SecurityState)
		security_state.SecurityState = new(pb.SecurityState)
		security_state.SecurityState.MovementDetected = new(bool)
		security_state.SecurityState.Tampered = new(bool)
		security_state.SecurityState.NightVision = new(bool)
		*security_state.SecurityState.MovementDetected = false
		*security_state.SecurityState.Tampered = false
		*security_state.SecurityState.NightVision = rand.Int() % 2 == 0
		device_state.TypeState = security_state

	}

	DEVICE_INFOS = append(DEVICE_INFOS, device_info)
	DEVICE_STATES = append(DEVICE_STATES, device_state)
}

func stateChange() {
	for {
		for i := range DEVICE_STATES {
			state := DEVICE_STATES[i]
			go func() {
				switch *state.WorkingState {
				case pb.WorkingState_STARTING:
					time.Sleep(1200 * time.Millisecond)
					*state.WorkingState = pb.WorkingState_ON
				case pb.WorkingState_STOPPING:
					time.Sleep(1200 * time.Millisecond)
					*state.WorkingState = pb.WorkingState_OFF
				}
			}()

			if *state.WorkingState == pb.WorkingState_ON {
				info := DEVICE_INFOS[i]
				switch *info.Type {
				case pb.DeviceType_METER:
					meter_info := info.TypeInfo.(*pb.DeviceInfo_Meter)
					meter_state := state.TypeState.(*pb.DeviceState_MeterState)
					switch *meter_info.Meter.Type {
					case pb.MeterType_BAROMETER:
						pressure := meter_state.MeterState.Value.(*pb.MeterState_Pressure)
						*pressure.Pressure.Pressure += rand.Float64()
					case pb.MeterType_CO_METER:
						level := meter_state.MeterState.Value.(*pb.MeterState_CoLevel)
						*level.CoLevel.Level += rand.Float64()*0.2 - 0.12
						if *level.CoLevel.Level < 0 {
							*level.CoLevel.Level = 0
						}
						// TODO danger
					case pb.MeterType_THERMOMETER:
						temperature := meter_state.MeterState.Value.(*pb.MeterState_Temperature)
						*temperature.Temperature.Value += rand.Float64() * 0.2

					}

				case pb.DeviceType_HEATER:
					heater_state := state.TypeState.(*pb.DeviceState_HeaterState)
					cur_temp := heater_state.HeaterState.CurrentTemp
					set_temp := heater_state.HeaterState.SetTemp
					cur_power := *heater_state.HeaterState.CurrentPower
					if *cur_temp < *set_temp {
						*cur_temp += float64(cur_power) / MAX_HEATER_POWER
					} else if *cur_temp > *set_temp {
						*cur_temp -= float64(cur_power) / MAX_HEATER_POWER
					}

				case pb.DeviceType_SECURITY:
					security_info := info.TypeInfo.(*pb.DeviceInfo_Security)
					_ = security_info
					security_state := state.TypeState.(*pb.DeviceState_SecurityState)
					if *security_state.SecurityState.MovementDetected {
						if rand.Int()%2 == 0 {
							*security_state.SecurityState.MovementDetected = false
						}
					} else {
						if rand.Int()%3 < 1 {
							*security_state.SecurityState.MovementDetected = true
						}
					}
					if rand.Int()%20 == 0 {
						*security_state.SecurityState.Tampered = true
					}
				}

			}
		}
		time.Sleep(400 * time.Millisecond)
	}
}

func main() {
	lis, err := net.Listen("tcp", "localhost:9009")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}
	server := grpc.NewServer()
	pb.RegisterDeviceRegistryServer(server, new(deviceRegistryServer))
	pb.RegisterHeaterControllerServer(server, new(heaterControllerServer))
	pb.RegisterSecurityControllerServer(server, new(securityControllerServer))

	for i := 0; i < DEVICE_AMOUNT; i += 1 {
		addRandomDevice()
	}
	go stateChange()

	if err := server.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
	log.Printf("Server listening at %v", lis.Addr())
}
