//
//  A2RSpinnerViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 24.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RSpinnerViewController.h"

#import "A2RTouchView.h"

typedef enum {
    A2RSpinnerModeTouch = 0,
    A2RSpinnerModeAcceleration,
}A2RSpinnerMode;

@interface A2RSpinnerViewController () <UIAccelerometerDelegate> {
    A2RSpinnerMode _mode;
    NSString *_OSCAddress;
    UIAccelerometer *_accelerometer;
}

@property (nonatomic, strong) NSDictionary *spinner;
@property (nonatomic, strong) A2RConnection *connection;
@property (strong, nonatomic) IBOutlet A2RTouchView *touchView;
@property (weak, nonatomic) IBOutlet UIButton *modeButton;

- (IBAction)modeButtonPressed:(id)sender;

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
    _mode = A2RSpinnerModeTouch;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Spinner", @"Spinner View title");
    
    if (_spinner[@"address"] != nil) {
        _OSCAddress = _spinner[@"address"];
    }
    else {
        _OSCAddress = _spinner[@"outs"][0][@"address"];
    }
    
    NSString *oscAddress = _OSCAddress;
    A2RSpinnerMode spinnerMode = _mode;
    A2RConnection *connection = _connection;
    [_touchView setTouchBlock:^(NSSet *touches, CGPoint position) {
        if (spinnerMode == A2RSpinnerModeTouch) {
            OSCMutableMessage *message = [[OSCMutableMessage alloc] init];
            message.address = oscAddress;
            [message addFloat:position.y];
            [connection sendOSCMessage:message];
            NSLog(@"Touch Position: %f %f", position.x, position.y);
        }
    }];
    
    _accelerometer = [UIAccelerometer sharedAccelerometer];
    _accelerometer.updateInterval = .1f;
    _accelerometer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modeButtonPressed:(id)sender {
    if (_mode == A2RSpinnerModeTouch) {
        _mode = A2RSpinnerModeAcceleration;
        [_modeButton setTitle:@"Mode: Accelleration" forState:UIControlStateNormal];
    }
    else {
        _mode = A2RSpinnerModeTouch;
        [_modeButton setTitle:@"Mode: Touch" forState:UIControlStateNormal];
    }
}

#pragma mark UIAccelerometer Delegate Methods

- (void)accelerometer:(UIAccelerometer *)meter didAccelerate:(UIAcceleration *)acceleration {
    if (_mode == A2RSpinnerModeAcceleration) {
        OSCMutableMessage *message = [[OSCMutableMessage alloc] init];
        message.address = _OSCAddress;
        [message addFloat:acceleration.z];
        [_connection sendOSCMessage:message];
        NSLog(@"Acceleration x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
    }
    
}
@end
