//
//  a2rViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 10.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RServerListController.h"
#import "SRWebSocket.h"


@interface A2RServerListController () <UITableViewDataSource, UITableViewDelegate, SRWebSocketDelegate> {
    BOOL _waitingForServerResponse;
}

@property (nonatomic, strong) NSArray *serverList;
@property (nonatomic, strong) SRWebSocket *socket;

@end

@implementation A2RServerListController

static NSString* kA2RServerListCell = @"a2rServerListCell";
static NSString* kA2RServerListKey = @"a2rServerList";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"Serverliste", @"Title of the Server list view");
    _waitingForServerResponse = NO;
    self.serverList = [[NSUserDefaults standardUserDefaults] arrayForKey:kA2RServerListKey];
    if (!_serverList.count) {
        NSString *serversFilePath = [[NSBundle mainBundle] pathForResource:@"A2RServers" ofType:@"plist"];
        self.serverList = [[NSArray alloc] initWithContentsOfFile:serversFilePath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.serverList = nil;
    self.socket = nil;
}

#pragma mark - TableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _serverList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kA2RServerListCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kA2RServerListCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *serverDict = (NSDictionary*)_serverList[indexPath.row];
    cell.textLabel.text = serverDict[@"name"];
    cell.detailTextLabel.text = serverDict[@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *throbber = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [throbber startAnimating];
    cell.accessoryView = throbber;
    _waitingForServerResponse = YES;
    
    NSDictionary *serverDict = (NSDictionary*)_serverList[indexPath.row];
    self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:serverDict[@"address"]]];
    _socket.delegate = self;
    [_socket open];
}

#pragma mark - SRWebSocket delegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"message: %@", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Socket to %@ opened", webSocket.url.host);
    NSDictionary *message = @{@"jsonrpc": @"2.0",
                              @"method": @"jams.getAll",
                              @"id": [NSNumber numberWithInt:1]};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];
    
    [webSocket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Could not conntec to %@ because of %@", webSocket.url.host, error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Closed connection to %@ with code %i because of %@", webSocket.url.host, code, reason);
    NSLog(@"This was %@ clean close.", (wasClean ? @"a" : @"NO"));
}



@end
