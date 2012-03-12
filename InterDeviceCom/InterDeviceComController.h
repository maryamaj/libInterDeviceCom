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


@interface InterDeviceComController : NSObject <GCDAsyncUdpSocketDelegate>
{
    NSMutableDictionary* _udpSockets;
    
}

+(id)sharedController;
-(void) connectToDevice:(DeviceInformation*) device onPort:(int) port;
-(void) broadcastData:(NSData *) data;
-(void) sendData:(NSData *) data toDevice:(DeviceInformation*) device;

@property (nonatomic, readonly) NSDictionary* udpSockets;
@end
