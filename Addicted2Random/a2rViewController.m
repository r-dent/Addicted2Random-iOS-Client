//
//  a2rViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 10.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "a2rViewController.h"

@interface a2rViewController ()

@end

@implementation a2rViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    _textView.text = [NSString stringWithFormat:@"%@%@", _textView.text, @"Hallo Welt "];
}
@end
