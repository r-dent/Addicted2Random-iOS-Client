//
//  A2RJamListController.m
//  Addicted2Random
//
//  Created by Roman Gille on 23.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RJamListController.h"

#import "A2RLayoutListViewController.h"
#import "A2RTableView.h"
#import "A2RTableViewCell.h"

@interface A2RJamListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* jams;
@property (nonatomic, strong) A2RConnection* connection;
@property (weak, nonatomic) IBOutlet A2RTableView *tableView;

@end

@implementation A2RJamListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithJams:(NSArray*)jams andConnection:(A2RConnection*)connection {
    self = [super init];
    self.connection = connection;
    self.jams = jams;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.title = NSLocalizedString(@"Jams", @"Title of jams list");
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([A2RTableViewCell class]) bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:[A2RTableViewCell identifier]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.connection = nil;
    self.jams = nil;
}

#pragma mark - TableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _jams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    A2RTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[A2RTableViewCell identifier]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *serverDict = (NSDictionary*)_jams[indexPath.row];
    cell.title.text = serverDict[@"title"];
    cell.description.text = serverDict[@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *jamsDict = (NSDictionary*)_jams[indexPath.row];
    [_connection dispatchRPCMethod:@"jams.getLayouts" withParameters:@[jamsDict[@"id"]] andCallback:^(id result) {
        NSArray *layouts = result;
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = nil;
        A2RLayoutListViewController *vc = [[A2RLayoutListViewController alloc]initWithLayouts:layouts andConnection:_connection];
        vc.jam = jamsDict;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [A2RTableViewCell cellHeight];
}

@end
