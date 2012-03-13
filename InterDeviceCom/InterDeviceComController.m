//
//  InterDeviceComController.m
//  InterDeviceCom
//
//  Created by Tommaso Piazza on 3/12/12.
//  Copyright (c) 2012 ChalmersTH. All rights reserved.
//

#import "InterDeviceComController.h"

@implementation InterDeviceComController

@synthesize udpSockets = _udpSockets;
@synthesize delegate = _delegate;

+ (id) sharedController
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        _udpSockets = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) connectToDevice:(DeviceInformation *)device onPort:(int)port{

    NSNumber* descByteValue = [NSNumber numberWithUnsignedChar:device.contactDescriptorByteValue];
    
    GCDAsyncUdpSocket* sock = [_udpSockets objectForKey:descByteValue];
    if(sock == nil){
    
        sock = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        NSError* error;
        
        [sock connectToHost:device.ipAddr onPort:port error:&error];
        [_udpSockets setObject:sock forKey:descByteValue];
    
    }
    
}

-(void) sendData:(NSData *) data toDevice:(DeviceInformation*) device{

    GCDAsyncUdpSocket* sock = [_udpSockets objectForKey:device];
    
    if(sock != nil)
        [sock sendData:data withTimeout:-1 tag:device.contactDescriptorByteValue];
    
}

-(void) broadcastData:(NSData *)data {

    NSArray* array = [_udpSockets allValues];
    
    for(int i = 0; i  < array.count; i++){
    
        GCDAsyncUdpSocket* sock = [array objectAtIndex:i];
        [sock sendData:data withTimeout:-1 tag:0];
    }

}

#pragma mark -
#pragma mark GCDAsyncUdpSocketDelegate Protocol

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    if ([_delegate conformsToProtocol:@protocol(InterDeviceComProtocol)]) {
        
        NSString* host = [GCDAsyncUdpSocket hostFromAddress:address];
        [_delegate receivedData:data fromHost:host];
    }
}

@end
