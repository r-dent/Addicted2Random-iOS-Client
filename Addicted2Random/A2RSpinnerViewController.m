//
//  A2RSpinnerViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 24.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RSpinnerViewController.h"

#import "A2RTouchView.h"

@interface A2RSpinnerViewController ()

@property (nonatomic, strong) NSDictionary *spinner;
@property (nonatomic, strong) A2RConnection *connection;

@end

@implementation A2RSpinnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSpinner:(NSDictionary *)spinner andConnection:(A2RConnection *)connection {
    self = [super init];
    self.spinner = spinner;
    self.connection = connection;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Spinner", @"Spinner View title");
    A2RTouchView *touchView = [[A2RTouchView alloc] init];
    touchView.frame = self.view.frame;
    [touchView setTouchBlock:^(NSSet *touches, CGPoint position) {
        A2ROSCValue* value = [A2ROSCValue valueWithObject:[NSNumber numberWithFloat:position.y] ofType:A2ROSCDataTypeFloat];
        [_connection sendValues:@[value] toOSCAddress:_spinner[@"address"]];
        NSLog(@"%f %f", position.x, position.y);
    }];
    [self.view addSubview:touchView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
