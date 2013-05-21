//
//  A2RLayoutListViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 23.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RLayoutListViewController.h"

#import "A2RSpinnerViewController.h"
#import "A2RTableView.h"
#import "A2RTableViewCell.h"

@interface A2RLayoutListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* layouts;
@property (nonatomic, strong) A2RConnection* connection;
@property (weak, nonatomic) IBOutlet A2RTableView *tableView;

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
    self.title = NSLocalizedString(@"Instruments", @"Title of layouts view");
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([A2RTableViewCell class]) bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:[A2RTableViewCell identifier]];
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
    A2RTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[A2RTableViewCell identifier]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *serverDict = (NSDictionary*)_layouts[indexPath.row];
    cell.title.text = serverDict[@"title"];
    cell.description.text = serverDict[@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *layoutDict = (NSDictionary*)_layouts[indexPath.row];
    [_connection dispatchRPCMethod:@"jams.getLayout" withParameters:@[_jam[@"id"] ,layoutDict[@"name"]] andCallback:^(id result) {
        NSDictionary *layout = result;
        NSArray *sections = layout[@"sections"];
        NSDictionary *spinnerElement;
        
        for (NSDictionary *section in sections) {
            if (((NSArray*)section[@"elements"]).count) {
                for (NSDictionary *element in section[@"elements"]) {
                    if ([@"Spinner" isEqualToString:element[@"type"]]) {
                        spinnerElement = element;
                        break;
                    }
                }
            }
        }
        
        if (spinnerElement != nil) {
            A2RSpinnerViewController *vc = [[A2RSpinnerViewController alloc] initWithSpinner:spinnerElement andConnection:_connection];
            [self.navigationController pushViewController:vc animated:YES];
        }
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = nil;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [A2RTableViewCell cellHeight];
}

@end
