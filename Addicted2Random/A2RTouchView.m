//
//  WBTouchView.m
//  WhiteboardTest
//
//  Created by Roman Gille on 19.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RTouchView.h"

typedef void(^WBTouchViewTouchBlock)(NSSet* touches, CGPoint position);

@interface A2RTouchView () {
    WBTouchViewTouchBlock _touchBlock;
}

@end

@implementation A2RTouchView 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTouchBlock:(void (^)(NSSet*, CGPoint))touchBlock {
    _touchBlock = touchBlock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    _touchBlock(touches, [touch locationInView:self]);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    _touchBlock(touches, [touch locationInView:self]);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    _touchBlock(touches, [touch locationInView:self]);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}

@end
