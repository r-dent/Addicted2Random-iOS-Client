//
//  A2RSplashViewController.m
//  Addicted2Random
//
//  Created by Roman Gille on 22.05.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RSplashViewController.h"

@interface A2RSplashViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *headlineImage;

@end

@implementation A2RSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)disappear {
    [UIView animateWithDuration:.3f animations:^{
        _logoImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
        _logoImage.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3f animations:^{
            _headlineImage.frame = CGRectMake(_headlineImage.frame.origin.x,
                                              self.view.frame.size.height,
                                              _headlineImage.frame.size.width,
                                              _headlineImage.frame.size.height);
            _headlineImage.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

@end
