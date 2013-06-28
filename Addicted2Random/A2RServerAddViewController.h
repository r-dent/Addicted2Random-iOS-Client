//
//  A2RServerAddViewController.h
//  Addicted2Random
//
//  Created by Roman Gille on 28.06.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface A2RServerAddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *serverName;
@property (weak, nonatomic) IBOutlet UITextField *description;
@property (weak, nonatomic) IBOutlet UITextField *uri;

- (id)initWithServerAddBlock:(void(^)(NSDictionary* serverDict))serverAddBlock;

@end
