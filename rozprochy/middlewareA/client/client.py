#!/usr/bin/env python3
import grpc  # type: ignore
from service_pb2 import *
from service_pb2_grpc import *

NO_DEVICE = -1

TYPE_NAMES = {
    METER: "Meter",
    HEATER: "Heater",
    SECURITY: "Security device",
}


def argf(fun):
    def wrapped(*args):
        global current_device
        if len(args) == 0:
            wrapped(current_device)
            return
        elif len(args) > 1:
            print("Too many arguments given")
            return
        try:
            fun(args[0])
        except Exception as e:
            print(e)
            return

    return wrapped


def check(id):
    global DEVICES
    if id not in DEVICES:
        if id == NO_DEVICE:
            print("No device selected!")
            return False
        print("No device with such id exists")
        return False
    return True


def list_devices(*args):
    global DEVICES
    if len(args) > 0:
        print("This command takes no arguments")
        return
    for dev in DEVICES.values():
        print(f'Dev {dev.id.id} ({TYPE_NAMES[dev.type]}): "{dev.name}"')


def select_device(*args):
    global DEVICES
    global current_device
    if len(args) == 0:
        print("Give device id")
        return
    elif len(args) > 1:
        print("Too many arguments given")
        return
    try:
        id = int(args[0])
        if id not in DEVICES:
            print("No such device")
            return
        current_device = id
    except:
        print("Argument must be an integer")
        return


@argf
def device_info(id):
    global DEVICES
    id = int(id)
    if not check(id):
        return
    devinfo = DEVICES[id]
    print(f'Device name: "{devinfo.name}"')
    print(f"Device type: {devinfo.type}")
    match devinfo.type:
        case DeviceType.METER:
            print(devinfo.meter)
        case DeviceType.HEATER:
            print(devinfo.heater)
        case DeviceType.SECURITY:
            print(devinfo.security)
    print()


@argf
def device_state(id):
    global DEVICES
    global registry_stub
    id = int(id)
    if not check(id):
        return
    response = registry_stub.GetDeviceState(Id(id=id))
    if response.status != 0:
        print("Failed getting device status")
        return
    print(response.state)


@argf
def device_actions(id):
    global DEVICES
    id = int(id)
    if not check(id):
        return
    print("Supported actions:")
    match DEVICES[id].type:
        case DeviceType.HEATER:
            print("set_temp - Set target temperature")
            print("set_power - Set operating power")
        case DeviceType.SECURITY:
            print("toggle_nv - Toggle night vision ability")
        case _:
            print("No actions supported yet")


def run(*args):
    global DEVICES, current_device
    global heater_stub, security_stub
    if len(args) == 0:
        print("Give at least one argument")
        return

    id = current_device
    action = args[0]
    values = args[1:]
    try:
        id = int(args[0])
        if len(args) == 1:
            print("Give action name")
            return
        action = args[1]
        values = args[2:]
    except:
        run(current_device, *args)
        return

    try:
        if not check(id):
            return
        match DEVICES[id].type:
            case DeviceType.HEATER:
                match action:
                    case "set_temp":
                        response = heater_stub.SetTemp(
                            TempInfo(id=Id(id=id), new_temp=float(values[0]))
                        )
                        if response.status == 0:
                            print("Action succeeded")
                        else:
                            print(
                                f"Action failed with code {response.status}"
                            )
                    case "set_power":
                        response = heater_stub.SetPower(
                            PowerInfo(id=Id(id=id), new_power=int(values[0]))
                        )
                        if response.status == 0:
                            print("Action succeeded")
                        else:
                            print(
                                f"Action failed with code {response.status}"
                            )
                    case _:
                        print("Action not supported")

            case DeviceType.SECURITY:
                match action:
                    case "toggle_nv":
                        response = security_stub.ToggleNightVision(Id(id=id))
                        if response.status == 0:
                            print("Action succeeded")
                        else:
                            print(
                                f"Action failed with code {response.status}"
                            )
                    case _:
                        print("Action not supported")
            case _:
                print("Device doesn't support actions")
    except Exception as e:
        print(e)


@argf
def toggle_device(id):
    global reigstry_stub
    id = int(id)
    if not check(id):
        return
    response = registry_stub.ToggleDevice(Id(id=id))
    if response.status != 0:
        print("Can't even turn device on/off!!")


def exit_program(*args):
    print("Exiting")
    exit(0)


GLOBAL_COMMANDS = {
    "/list": list_devices,
    "/choose": select_device,
    "/info": device_info,
    "/state": device_state,
    "/toggle": toggle_device,
    "/actions": device_actions,
    "/run": run,
    "/exit": exit_program,
    "/quit": exit_program,
    #
    "/l": list_devices,
    "/c": select_device,
    "/i": device_info,
    "/s": device_state,
    "/t": toggle_device,
    "/a": device_actions,
    "/r": run,
    "/e": exit_program,
    "/q": exit_program,
}

with grpc.insecure_channel("localhost:9009") as channel:
    registry_stub = DeviceRegistryStub(channel)
    heater_stub = HeaterControllerStub(channel)
    security_stub = SecurityControllerStub(channel)

    response = registry_stub.GetDevices(Empty())
    if response.status != 0:
        print(f"Error getting devices: {response.status}")
        exit(1)

    current_device = NO_DEVICE
    DEVICES = {}
    for dev in response.devices.devices:
        DEVICES[dev.id.id] = dev

    while True:
        command = input().split()
        if len(command) == 0:
            continue
        if command[0] not in GLOBAL_COMMANDS:
            print(f"{command[0]}: No such command!")
            continue
        GLOBAL_COMMANDS[command[0]](*command[1:])  # type: ignore
