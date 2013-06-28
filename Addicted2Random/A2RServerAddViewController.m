//
//  A2RServerAddViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 28.06.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RServerAddViewController.h"

typedef void(^A2RServerAddBlock)(NSDictionary* serverDict);

@interface A2RServerAddViewController () <UITextFieldDelegate> {
    A2RServerAddBlock _serverAddBlock;
}

@end

@implementation A2RServerAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithServerAddBlock:(void (^)(NSDictionary *))serverAddBlock {
    self = [super init];
    _serverAddBlock = serverAddBlock;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"add server", @"Server add view title");
    [self.navigationController setNavigationBarHidden:NO];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"button_add"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"add", nil) style:UIBarButtonSystemItemAdd target:self action:@selector(didPressAddButton:)];
    [self.navigationItem.rightBarButtonItem setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(didPressCancelButton:)];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_serverName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)validateAndDismiss {
    if (_uri.text.length > 5 && _serverName.text.length > 0) {
        NSURL *url = [NSURL URLWithString:_uri.text];
        NSString *scheme = url.scheme.lowercaseString;
        
        if ([scheme isEqualToString:@"ws"] || [scheme isEqualToString:@"http"] || [scheme isEqualToString:@"wss"] || [scheme isEqualToString:@"https"]) {
            NSDictionary *serverDict = [NSDictionary dictionaryWithObjectsAndKeys:_serverName.text, @"name", _description.text, @"description", _uri.text, @"address", nil];
            _serverAddBlock(serverDict);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self warn:@"The server uri is not correct"];
        }
    }
    else {
        [self warn:@"Please fill all necessary fields"];
    }
}

- (void)warn:(NSString*)warning {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(warning, nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
    
}

#pragma mark - Button Handling

- (void)didPressAddButton:(id)sender {
    [self validateAndDismiss];
}

- (void)didPressCancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _serverName) {
        [_description becomeFirstResponder];
    }
    else if (textField == _description) {
        [_uri becomeFirstResponder];
    }
    else if (textField == _uri) {
        [self validateAndDismiss];
    }
    return YES;
}

@end
