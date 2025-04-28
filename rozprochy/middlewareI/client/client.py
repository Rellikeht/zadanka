#!/usr/bin/env python3

import sys
import Ice  # type: ignore
import Demo


def run_client(communicator):
    endpoint = f"default -h localhost -p 10000"

    base = communicator.stringToProxy(f"Demo/SimpleService:{endpoint}")

    while True:
        print("\nChoose an operation:")
        print("1. Access a dedicated servant object")
        print("2. Access a shared servant object")
        print("3. Exit")
        choice = input("Choice: ").strip()

        if choice == "3":
            break

        if choice == "1" or choice == "2":
            category = "dedicated" if choice == "1" else "shared"
            object_name = (
                input(f"Enter object name (e.g., object1): ").strip()
                or "object1"
            )

            object_id = f"{category}/{object_name}"
            specific_base = communicator.stringToProxy(
                f"{object_id}:{endpoint}"
            )

            use_checked = (
                input("Use checkedCast? (y/n, default: y): ").strip().lower()
                != "n"
            )

            print("\nAttempting to cast the proxy...")
            if use_checked:
                print("Using checkedCast (will verify the object type)")
                simple_service = Demo.SimpleServicePrx.checkedCast(
                    specific_base
                )
            else:
                print("Using uncheckedCast (won't verify the object type)")
                simple_service = Demo.SimpleServicePrx.uncheckedCast(
                    specific_base
                )

            if not simple_service:
                print("Invalid proxy")
                continue

            while True:
                print(
                    "\nProxy successfully created. Choose an operation to execute:"
                )
                print("1. getIdentity()")
                print("2. getServantType()")
                print("3. process()")
                print("4. Call all methods")
                print("5. Back to main menu")
                op_choice = input("Operation choice: ").strip()

                try:
                    if op_choice == "1":
                        result = simple_service.getIdentity()
                        print(f"Identity: {result}")
                    elif op_choice == "2":
                        result = simple_service.getServantType()
                        print(f"Servant type: {result}")
                    elif op_choice == "3":
                        message = (
                            input("Enter message to process: ").strip()
                            or "Hello ICE!"
                        )
                        result = simple_service.process(message)
                        print(f"Result: {result}")
                    elif op_choice == "4":
                        identity = simple_service.getIdentity()
                        print(f"Identity: {identity}")

                        servant_type = simple_service.getServantType()
                        print(f"Servant type: {servant_type}")

                        message = (
                            input("Enter message to process: ").strip()
                            or "Hello ICE!"
                        )
                        result = simple_service.process(message)
                        print(f"Process result: {result}")
                    elif op_choice == "5":
                        break
                    else:
                        print("Invalid choice")
                except Ice.Exception as e:
                    print(f"Ice exception: {e}")
        else:
            print("Invalid choice")


def main():
    status = 0
    communicator = None

    try:
        communicator = Ice.initialize(sys.argv)
        run_client(communicator)
    except Ice.Exception as e:
        print(f"Error: {e}")
        status = 1
    except KeyboardInterrupt:
        print("\nExiting...")
    finally:
        if communicator:
            communicator.destroy()

    return status


if __name__ == "__main__":
    sys.exit(main())
