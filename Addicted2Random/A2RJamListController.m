//
//  A2RJamListController.m
//  Addicted2Random
//
//  Created by Roman Gille on 23.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RJamListController.h"

@interface A2RJamListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* jams;
@property (nonatomic, strong) A2RConnection* connection;

@end

@implementation A2RJamListController

static NSString* kA2RJamListCell = @"a2rServerListCell";

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _jams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kA2RJamListCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kA2RJamListCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *serverDict = (NSDictionary*)_jams[indexPath.row];
    cell.textLabel.text = serverDict[@"title"];
    cell.detailTextLabel.text = serverDict[@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *jamsDict = (NSDictionary*)_jams[indexPath.row];
    [_connection dispatchRPCMethod:@"jams.getLayouts" withParameters:@[jamsDict[@"id"]] andCallback:^(id result) {
        NSArray *layouts = result;
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = nil;
    }];
}

@end
