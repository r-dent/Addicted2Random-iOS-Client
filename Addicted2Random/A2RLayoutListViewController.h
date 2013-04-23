//
//  A2RLayoutListViewController.h
//  Addicted2Random
//
//  Created by Roman Gille on 23.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "A2RConnection.h"

@interface A2RLayoutListViewController : UIViewController

@property (nonatomic, strong) NSDictionary *jam;

- (id)initWithLayouts:(NSArray*)layouts andConnection:(A2RConnection*)connection;

@end
