//
//  A2RConnection.h
//  Addicted2Random
//
//  Created by Roman Gille on 22.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OSCPacket.h"

typedef void (^A2RConnectionEstablishedBlock)(void);
typedef void (^A2RConnectionClosedBlock)(void);
typedef void (^A2RConnectionFailedBlock)(void);
typedef void (^A2RConnectionJSON_RPCCompleteBlock)(id result);

@interface A2RConnection : NSObject

- (id)initWithURL:(NSURL *)url established:(A2RConnectionEstablishedBlock)establishedBlock failed:(A2RConnectionFailedBlock)failed;

- (void)closeWithCallback:(void (^)(void))closedBlock;

- (void)dispatchRPCMethod:(NSString *)methodString withParameters:(NSArray *)parameters andCallback:(void (^)(id result))completionBlock;

- (void)sendOSCMessage:(OSCMutableMessage*)message;

@end
