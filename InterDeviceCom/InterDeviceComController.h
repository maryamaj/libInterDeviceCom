//
//  InterDeviceComController.h
//  InterDeviceCom
//
//  Created by Tommaso Piazza on 3/12/12.
//  Copyright (c) 2012 ChalmersTH. All rights reserved.
//

#define kIDCPORT 4765

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "DeviceInformation.h"

@protocol InterDeviceComProtocol <NSObject>

@required

-(void) receivedData:(NSData*) data fromHost:(NSString*) host;

@end


@interface InterDeviceComController : NSObject <GCDAsyncUdpSocketDelegate>
{
    NSMutableDictionary* _udpSockets;
    __weak id <InterDeviceComProtocol> _delegate;
}

@property (nonatomic, readonly) NSDictionary* udpSockets;
@property (weak, nonatomic) id<InterDeviceComProtocol> delegate;

+(id)sharedController;
-(void) connectToDevice:(DeviceInformation*) device onPort:(int) port;
-(void) broadcastData:(NSData *) data;
-(void) sendData:(NSData *) data toDevice:(DeviceInformation*) device;
@end
