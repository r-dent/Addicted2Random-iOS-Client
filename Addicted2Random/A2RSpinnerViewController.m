//
//  A2RSpinnerViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 24.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RSpinnerViewController.h"

@interface A2RSpinnerViewController ()

@property (nonatomic, strong) NSDictionary *spinner;

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

- (id)initWithSpinner:(NSDictionary *)spinner {
    self = [super init];
    self.spinner = spinner;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Spinner", @"Spinner View title");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
