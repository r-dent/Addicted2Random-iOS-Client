//
//  A2RJamListController.h
//  Addicted2Random
//
//  Created by Roman Gille on 23.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "A2RConnection.h"

@interface A2RJamListController : UIViewController

- (id)initWithJams:(NSArray*)jams andConnection:(A2RConnection*)connection;

@end
