// head and helpers {{{

// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.5.1
// - protoc             v5.29.4
// source: common/service.proto

package common

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.64.0 or later.
const _ = grpc.SupportPackageIsVersion9

const (
	DeviceRegistry_GetDevices_FullMethodName     = "/common.DeviceRegistry/GetDevices"
	DeviceRegistry_GetDeviceState_FullMethodName = "/common.DeviceRegistry/GetDeviceState"
	DeviceRegistry_ToggleDevice_FullMethodName   = "/common.DeviceRegistry/ToggleDevice"
)

// DeviceRegistryClient is the client API for DeviceRegistry service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type DeviceRegistryClient interface {
	GetDevices(ctx context.Context, in *Empty, opts ...grpc.CallOption) (*DevInfoResponse, error)
	GetDeviceState(ctx context.Context, in *Id, opts ...grpc.CallOption) (*DevStateResponse, error)
	ToggleDevice(ctx context.Context, in *Id, opts ...grpc.CallOption) (*SimpleResponse, error)
}

type deviceRegistryClient struct {
	cc grpc.ClientConnInterface
}

func NewDeviceRegistryClient(cc grpc.ClientConnInterface) DeviceRegistryClient {
	return &deviceRegistryClient{cc}
}

func (c *deviceRegistryClient) GetDevices(ctx context.Context, in *Empty, opts ...grpc.CallOption) (*DevInfoResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(DevInfoResponse)
	err := c.cc.Invoke(ctx, DeviceRegistry_GetDevices_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *deviceRegistryClient) GetDeviceState(ctx context.Context, in *Id, opts ...grpc.CallOption) (*DevStateResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(DevStateResponse)
	err := c.cc.Invoke(ctx, DeviceRegistry_GetDeviceState_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *deviceRegistryClient) ToggleDevice(ctx context.Context, in *Id, opts ...grpc.CallOption) (*SimpleResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(SimpleResponse)
	err := c.cc.Invoke(ctx, DeviceRegistry_ToggleDevice_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// DeviceRegistryServer is the server API for DeviceRegistry service.
// All implementations must embed UnimplementedDeviceRegistryServer
// for forward compatibility.
type DeviceRegistryServer interface {
	GetDevices(context.Context, *Empty) (*DevInfoResponse, error)
	GetDeviceState(context.Context, *Id) (*DevStateResponse, error)
	ToggleDevice(context.Context, *Id) (*SimpleResponse, error)
	mustEmbedUnimplementedDeviceRegistryServer()
}

// UnimplementedDeviceRegistryServer must be embedded to have
// forward compatible implementations.
//
// NOTE: this should be embedded by value instead of pointer to avoid a nil
// pointer dereference when methods are called.
type UnimplementedDeviceRegistryServer struct{}

func (UnimplementedDeviceRegistryServer) GetDevices(context.Context, *Empty) (*DevInfoResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetDevices not implemented")
}
func (UnimplementedDeviceRegistryServer) GetDeviceState(context.Context, *Id) (*DevStateResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetDeviceState not implemented")
}
func (UnimplementedDeviceRegistryServer) ToggleDevice(context.Context, *Id) (*SimpleResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method ToggleDevice not implemented")
}
func (UnimplementedDeviceRegistryServer) mustEmbedUnimplementedDeviceRegistryServer() {}
func (UnimplementedDeviceRegistryServer) testEmbeddedByValue()                        {}

// UnsafeDeviceRegistryServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to DeviceRegistryServer will
// result in compilation errors.
type UnsafeDeviceRegistryServer interface {
	mustEmbedUnimplementedDeviceRegistryServer()
}

func RegisterDeviceRegistryServer(s grpc.ServiceRegistrar, srv DeviceRegistryServer) {
	// If the following call pancis, it indicates UnimplementedDeviceRegistryServer was
	// embedded by pointer and is nil.  This will cause panics if an
	// unimplemented method is ever invoked, so we test this at initialization
	// time to prevent it from happening at runtime later due to I/O.
	if t, ok := srv.(interface{ testEmbeddedByValue() }); ok {
		t.testEmbeddedByValue()
	}
	s.RegisterService(&DeviceRegistry_ServiceDesc, srv)
}

func _DeviceRegistry_GetDevices_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(Empty)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(DeviceRegistryServer).GetDevices(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: DeviceRegistry_GetDevices_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(DeviceRegistryServer).GetDevices(ctx, req.(*Empty))
	}
	return interceptor(ctx, in, info, handler)
}

func _DeviceRegistry_GetDeviceState_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(Id)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(DeviceRegistryServer).GetDeviceState(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: DeviceRegistry_GetDeviceState_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(DeviceRegistryServer).GetDeviceState(ctx, req.(*Id))
	}
	return interceptor(ctx, in, info, handler)
}

func _DeviceRegistry_ToggleDevice_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(Id)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(DeviceRegistryServer).ToggleDevice(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: DeviceRegistry_ToggleDevice_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(DeviceRegistryServer).ToggleDevice(ctx, req.(*Id))
	}
	return interceptor(ctx, in, info, handler)
}

// DeviceRegistry_ServiceDesc is the grpc.ServiceDesc for DeviceRegistry service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var DeviceRegistry_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "common.DeviceRegistry",
	HandlerType: (*DeviceRegistryServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "GetDevices",
			Handler:    _DeviceRegistry_GetDevices_Handler,
		},
		{
			MethodName: "GetDeviceState",
			Handler:    _DeviceRegistry_GetDeviceState_Handler,
		},
		{
			MethodName: "ToggleDevice",
			Handler:    _DeviceRegistry_ToggleDevice_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "common/service.proto",
}

const (
	HeaterController_SetTemp_FullMethodName  = "/common.HeaterController/SetTemp"
	HeaterController_SetPower_FullMethodName = "/common.HeaterController/SetPower"
)

// HeaterControllerClient is the client API for HeaterController service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type HeaterControllerClient interface {
	SetTemp(ctx context.Context, in *TempInfo, opts ...grpc.CallOption) (*SimpleResponse, error)
	SetPower(ctx context.Context, in *PowerInfo, opts ...grpc.CallOption) (*SimpleResponse, error)
}

type heaterControllerClient struct {
	cc grpc.ClientConnInterface
}

func NewHeaterControllerClient(cc grpc.ClientConnInterface) HeaterControllerClient {
	return &heaterControllerClient{cc}
}

func (c *heaterControllerClient) SetTemp(ctx context.Context, in *TempInfo, opts ...grpc.CallOption) (*SimpleResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(SimpleResponse)
	err := c.cc.Invoke(ctx, HeaterController_SetTemp_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *heaterControllerClient) SetPower(ctx context.Context, in *PowerInfo, opts ...grpc.CallOption) (*SimpleResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(SimpleResponse)
	err := c.cc.Invoke(ctx, HeaterController_SetPower_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// HeaterControllerServer is the server API for HeaterController service.
// All implementations must embed UnimplementedHeaterControllerServer
// for forward compatibility.
type HeaterControllerServer interface {
	SetTemp(context.Context, *TempInfo) (*SimpleResponse, error)
	SetPower(context.Context, *PowerInfo) (*SimpleResponse, error)
	mustEmbedUnimplementedHeaterControllerServer()
}

// UnimplementedHeaterControllerServer must be embedded to have
// forward compatible implementations.
//
// NOTE: this should be embedded by value instead of pointer to avoid a nil
// pointer dereference when methods are called.
type UnimplementedHeaterControllerServer struct{}

func (UnimplementedHeaterControllerServer) SetTemp(context.Context, *TempInfo) (*SimpleResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method SetTemp not implemented")
}
func (UnimplementedHeaterControllerServer) SetPower(context.Context, *PowerInfo) (*SimpleResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method SetPower not implemented")
}
func (UnimplementedHeaterControllerServer) mustEmbedUnimplementedHeaterControllerServer() {}
func (UnimplementedHeaterControllerServer) testEmbeddedByValue()                          {}

// UnsafeHeaterControllerServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to HeaterControllerServer will
// result in compilation errors.
type UnsafeHeaterControllerServer interface {
	mustEmbedUnimplementedHeaterControllerServer()
}

func RegisterHeaterControllerServer(s grpc.ServiceRegistrar, srv HeaterControllerServer) {
	// If the following call pancis, it indicates UnimplementedHeaterControllerServer was
	// embedded by pointer and is nil.  This will cause panics if an
	// unimplemented method is ever invoked, so we test this at initialization
	// time to prevent it from happening at runtime later due to I/O.
	if t, ok := srv.(interface{ testEmbeddedByValue() }); ok {
		t.testEmbeddedByValue()
	}
	s.RegisterService(&HeaterController_ServiceDesc, srv)
}

func _HeaterController_SetTemp_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TempInfo)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(HeaterControllerServer).SetTemp(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: HeaterController_SetTemp_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(HeaterControllerServer).SetTemp(ctx, req.(*TempInfo))
	}
	return interceptor(ctx, in, info, handler)
}

func _HeaterController_SetPower_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(PowerInfo)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(HeaterControllerServer).SetPower(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: HeaterController_SetPower_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(HeaterControllerServer).SetPower(ctx, req.(*PowerInfo))
	}
	return interceptor(ctx, in, info, handler)
}

// HeaterController_ServiceDesc is the grpc.ServiceDesc for HeaterController service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var HeaterController_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "common.HeaterController",
	HandlerType: (*HeaterControllerServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "SetTemp",
			Handler:    _HeaterController_SetTemp_Handler,
		},
		{
			MethodName: "SetPower",
			Handler:    _HeaterController_SetPower_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "common/service.proto",
}

const (
	SecurityController_ToggleNightVision_FullMethodName = "/common.SecurityController/ToggleNightVision"
)

// SecurityControllerClient is the client API for SecurityController service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type SecurityControllerClient interface {
	ToggleNightVision(ctx context.Context, in *Id, opts ...grpc.CallOption) (*SimpleResponse, error)
}

type securityControllerClient struct {
	cc grpc.ClientConnInterface
}

func NewSecurityControllerClient(cc grpc.ClientConnInterface) SecurityControllerClient {
	return &securityControllerClient{cc}
}

func (c *securityControllerClient) ToggleNightVision(ctx context.Context, in *Id, opts ...grpc.CallOption) (*SimpleResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(SimpleResponse)
	err := c.cc.Invoke(ctx, SecurityController_ToggleNightVision_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// SecurityControllerServer is the server API for SecurityController service.
// All implementations must embed UnimplementedSecurityControllerServer
// for forward compatibility.
type SecurityControllerServer interface {
	ToggleNightVision(context.Context, *Id) (*SimpleResponse, error)
	mustEmbedUnimplementedSecurityControllerServer()
}

// UnimplementedSecurityControllerServer must be embedded to have
// forward compatible implementations.
//
// NOTE: this should be embedded by value instead of pointer to avoid a nil
// pointer dereference when methods are called.
type UnimplementedSecurityControllerServer struct{}

func (UnimplementedSecurityControllerServer) ToggleNightVision(context.Context, *Id) (*SimpleResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method ToggleNightVision not implemented")
}
func (UnimplementedSecurityControllerServer) mustEmbedUnimplementedSecurityControllerServer() {}
func (UnimplementedSecurityControllerServer) testEmbeddedByValue()                            {}

// UnsafeSecurityControllerServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to SecurityControllerServer will
// result in compilation errors.
type UnsafeSecurityControllerServer interface {
	mustEmbedUnimplementedSecurityControllerServer()
}

func RegisterSecurityControllerServer(s grpc.ServiceRegistrar, srv SecurityControllerServer) {
	// If the following call pancis, it indicates UnimplementedSecurityControllerServer was
	// embedded by pointer and is nil.  This will cause panics if an
	// unimplemented method is ever invoked, so we test this at initialization
	// time to prevent it from happening at runtime later due to I/O.
	if t, ok := srv.(interface{ testEmbeddedByValue() }); ok {
		t.testEmbeddedByValue()
	}
	s.RegisterService(&SecurityController_ServiceDesc, srv)
}

func _SecurityController_ToggleNightVision_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(Id)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(SecurityControllerServer).ToggleNightVision(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: SecurityController_ToggleNightVision_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(SecurityControllerServer).ToggleNightVision(ctx, req.(*Id))
	}
	return interceptor(ctx, in, info, handler)
}

// SecurityController_ServiceDesc is the grpc.ServiceDesc for SecurityController service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var SecurityController_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "common.SecurityController",
	HandlerType: (*SecurityControllerServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "ToggleNightVision",
			Handler:    _SecurityController_ToggleNightVision_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "common/service.proto",
}
