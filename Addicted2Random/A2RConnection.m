//
//  A2RConnection.m
//  Addicted2Random
//
//  Created by Roman Gille on 22.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RConnection.h"

#import "SRWebSocket.h"
#import "OSCPacket.h"


@interface A2RConnection () <SRWebSocketDelegate> {
    int _RPCIdCounter;
    A2RConnectionEstablishedBlock _establishedBlock;
    A2RConnectionFailedBlock _failBlock;
    A2RConnectionClosedBlock _closedBlock;
    NSTimer *_socketTimeoutTimer;
}

@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, strong) NSMutableDictionary *callbacksDict;

@end

@implementation A2RConnection

- (id)initWithURL:(NSURL *)url established:(A2RConnectionEstablishedBlock)establishedBlock failed:(A2RConnectionFailedBlock)failed {
    self = [super init];
    _RPCIdCounter = 0;
    self.socket = [[SRWebSocket alloc] initWithURL:url];
    _socket.delegate = self;
    self.callbacksDict = [NSMutableDictionary dictionary];
    _establishedBlock = establishedBlock;
    _failBlock = failed;
    _socketTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:10.f
                                                           target:self
                                                         selector:@selector(socketConnectionTimedOut)
                                                         userInfo:nil
                                                          repeats:NO];
    [_socket open];
    return self;
}

- (void)dealloc {
    self.socket = nil;
    if (_socketTimeoutTimer != nil) {
        [_socketTimeoutTimer invalidate];
    }
}

- (void)closeWithCallback:(void (^)(void))closedBlock {
    _closedBlock = closedBlock;
    if (_socket != nil && _socket.readyState < SR_CLOSING) {
        [_socket close];
    }
    else if(_closedBlock){
        _closedBlock();
    }
}

- (void)socketConnectionTimedOut {
    [_socketTimeoutTimer invalidate];
    _socketTimeoutTimer = nil;
    [_socket close];
    if (_failBlock) {
        _failBlock();
    }
}

- (void)dispatchRPCMethod:(NSString *)methodString withParameters:(NSArray *)parameters andCallback:(void (^)(id result))completionBlock {
    _RPCIdCounter++;
    parameters = (parameters.count) ? parameters : [NSArray array];
    NSDictionary *message = @{@"jsonrpc": @"2.0",
                              @"method": methodString,
                              @"params": parameters,
                              @"id": [NSNumber numberWithInt:_RPCIdCounter]};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];
    
    [_callbacksDict setObject:completionBlock forKey:[NSString stringWithFormat:@"%i", _RPCIdCounter]];
    
    [_socket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    
}

- (void)sendOSCMessage:(OSCMutableMessage *)message {
    //NSLog(@"OSC to %@ with value %@", message.address, message.arguments);
    [_socket send:[message encode]];
}

#pragma mark - SRWebSocket delegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"message: %@", message);
    NSError *error;
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:[((NSString*)message) dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:&error];
    A2RConnectionJSON_RPCCompleteBlock completionBlock = _callbacksDict[[NSString stringWithFormat:@"%@", messageDict[@"id"]]];
    completionBlock(messageDict[@"result"]);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Socket to %@ opened", webSocket.url.host);
    [_socketTimeoutTimer invalidate];
    if (_establishedBlock) {
        _establishedBlock();
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Could not conntec to %@ because of %@", webSocket.url.host, error);
    [_socketTimeoutTimer invalidate];
    if (_failBlock) {
        _failBlock();
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Closed connection to %@ with code %i because of %@", webSocket.url.host, code, reason);
    NSLog(@"This was %@ clean close.", (wasClean ? @"a" : @"NO"));
    [_socketTimeoutTimer invalidate];
    if (_closedBlock) {
        _closedBlock();
    }
}

@end
