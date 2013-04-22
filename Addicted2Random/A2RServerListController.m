//
//  a2rViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 10.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RServerListController.h"
#import "SRWebSocket.h"


@interface A2RServerListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *serverList;

@end

@implementation A2RServerListController

static NSString* kA2RServerListCell = @"a2rServerListCell";
static NSString* kA2RServerListKey = @"a2rServerList";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"Serverliste", @"Title of the Server list view");
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
}


@end
