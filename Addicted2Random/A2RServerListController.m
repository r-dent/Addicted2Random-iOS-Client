//
//  a2rViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 10.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RServerListController.h"

#import "A2RConnection.h"
#import "A2RJamListController.h"
#import "A2RTableView.h"
#import "A2RTableViewCell.h"
#import "A2RServerAddViewController.h"


@interface A2RServerListController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL _waitingForServerResponse;
}

@property (nonatomic, strong) NSMutableArray *serverList;
@property (nonatomic, strong) A2RConnection *connection;
@property (weak, nonatomic) IBOutlet A2RTableView *tableView;

@end

@implementation A2RServerListController

static NSString* kA2RServerListKey = @"a2rServerList";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"addicted2random", @"Title of the Server list view");
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([A2RTableViewCell class]) bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:[A2RTableViewCell identifier]];
    
    _waitingForServerResponse = NO;
    self.serverList = [[[NSUserDefaults standardUserDefaults] arrayForKey:kA2RServerListKey] mutableCopy];
    if (!_serverList.count) {
        NSString *serversFilePath = [[NSBundle mainBundle] pathForResource:@"A2RServers" ofType:@"plist"];
        self.serverList = [[NSMutableArray alloc] initWithContentsOfFile:serversFilePath];
    }

    UIImage *backgroundImage = [[UIImage imageNamed:@"button_add"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add server" style:UIBarButtonSystemItemAdd target:self action:@selector(didPressAddServerButton:)];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.serverList = nil;
    self.connection = nil;
}

#pragma mark - TableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _serverList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    A2RTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[A2RTableViewCell identifier]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *serverDict = (NSDictionary*)_serverList[indexPath.row];
    cell.title.text = serverDict[@"name"];
    cell.description.text = serverDict[@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    A2RTableViewCell *cell = (A2RTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (_connection != nil) {
        [_connection closeWithCallback:^(void) {
            self.connection = nil;
            cell.style = A2RTableViewCellStyleDisclosure;
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        }];
    }
    else {
        NSDictionary *serverDict = (NSDictionary*)_serverList[indexPath.row];
        self.connection = [[A2RConnection alloc] initWithURL:[NSURL URLWithString:serverDict[@"address"]] established:^{
            [_connection dispatchRPCMethod:@"jams.getAll" withParameters:nil andCallback:^(id result) {
                NSArray *jams = result;
                cell.style = A2RTableViewCellStyleDisclosure;
                A2RJamListController* vc = [[A2RJamListController alloc] initWithJams:jams andConnection:_connection];
                vc.title = [NSString stringWithFormat:NSLocalizedString(@"Jams@%@", @"Title of Jam list controller."), serverDict[@"name"]];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        } failed:^{
            cell.style = A2RTableViewCellStyleDisclosure;
        }];
        cell.style = A2RTableViewCellStyleLoading;
        _waitingForServerResponse = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [A2RTableViewCell cellHeight];
}

#pragma mark - Button Handling

- (void)didPressAddServerButton:(id)sender {
    A2RServerAddViewController *vc = [[A2RServerAddViewController alloc] initWithServerAddBlock:^(NSDictionary *serverDict) {
        [_serverList addObject:serverDict];
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
