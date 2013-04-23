//
//  A2RLayoutListViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 23.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RLayoutListViewController.h"

@interface A2RLayoutListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* layouts;
@property (nonatomic, strong) A2RConnection* connection;

@end

@implementation A2RLayoutListViewController

static NSString *kA2RLayoutCellIdentifier = @"A2RLayoutCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLayouts:(NSArray*)layouts andConnection:(A2RConnection*)connection {
    self = [super init];
    self.connection = connection;
    self.layouts = layouts;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Layouts", @"Title of layouts view");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    self.connection = nil;
    self.layouts = nil;
}

#pragma mark - TableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kA2RLayoutCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kA2RLayoutCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *serverDict = (NSDictionary*)_layouts[indexPath.row];
    cell.textLabel.text = serverDict[@"title"];
    cell.detailTextLabel.text = serverDict[@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *layoutDict = (NSDictionary*)_layouts[indexPath.row];
    [_connection dispatchRPCMethod:@"jams.getLayout" withParameters:@[_jam[@"id"] ,layoutDict[@"name"]] andCallback:^(id result) {
        NSString *layout = result;
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = nil;
    }];
}

@end
