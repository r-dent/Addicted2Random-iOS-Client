//
//  A2RConnection.m
//  Addicted2Random
//
//  Created by Roman Gille on 22.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RConnection.h"

#import "SRWebSocket.h"

typedef void (^A2RConnectionEstablishedBlock)(void);
typedef void (^A2RConnectionJSON_RPCCompleteBlock)(id result);

@interface A2RConnection () <SRWebSocketDelegate> {
    int _RPCIdCounter;
    A2RConnectionEstablishedBlock _establishedBlock;
}

@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, strong) NSMutableDictionary *callbacksDict;

@end

@implementation A2RConnection

- (id)initWithURL:(NSURL *)url established:(void (^)(void))establishedBlock {
    self = [super init];
    _RPCIdCounter = 0;
    self.socket = [[SRWebSocket alloc] initWithURL:url];
    _socket.delegate = self;
    self.callbacksDict = [NSMutableDictionary dictionary];
    [_socket open];
    _establishedBlock = establishedBlock;
    return self;
}

- (void)dispatchRPCMethod:(NSString *)methodString withParameters:(NSString *)parametersString andCallback:(void (^)(id))completionBlock {
    _RPCIdCounter++;
    NSDictionary *message = @{@"jsonrpc": @"2.0",
                              @"method": methodString,
                              @"parameters": parametersString,
                              @"id": [NSNumber numberWithInt:_RPCIdCounter]};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];
    
    [_callbacksDict setObject:completionBlock forKey:[NSString stringWithFormat:@"%i", _RPCIdCounter]];
    
    [_socket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    
}

#pragma mark - SRWebSocket delegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"message: %@", [message class]);
    NSError *error;
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:[((NSString*)message) dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:&error];
    A2RConnectionJSON_RPCCompleteBlock completionBlock = _callbacksDict[[NSString stringWithFormat:@"%@", messageDict[@"id"]]];
    completionBlock(messageDict[@"result"]);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Socket to %@ opened", webSocket.url.host);
    _establishedBlock();
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Could not conntec to %@ because of %@", webSocket.url.host, error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Closed connection to %@ with code %i because of %@", webSocket.url.host, code, reason);
    NSLog(@"This was %@ clean close.", (wasClean ? @"a" : @"NO"));
}

@end
