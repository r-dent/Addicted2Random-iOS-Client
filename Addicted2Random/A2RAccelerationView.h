//
//  A2RAccelerationView.h
//  Addicted2Random
//
//  Created by Roman Gille on 26.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol A2RAccelerationViewDelegate;


@interface A2RAccelerationView : UIView

@property (nonatomic, strong) IBOutlet id<A2RAccelerationViewDelegate> delegate;
@property (nonatomic, assign) BOOL active;

@end


@protocol A2RAccelerationViewDelegate <NSObject>

- (void)valueDidChange:(CGFloat)value;

@end
