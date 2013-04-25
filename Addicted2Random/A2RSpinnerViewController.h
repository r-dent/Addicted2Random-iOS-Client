//
//  A2RSpinnerViewController.h
//  Addicted2Random
//
//  Created by Roman Gille on 24.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "A2RConnection.h"

@interface A2RSpinnerViewController : UIViewController

- (id)initWithSpinner:(NSDictionary *)spinner andConnection:(A2RConnection *)connection;

@end
