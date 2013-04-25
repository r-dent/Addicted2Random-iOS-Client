//
//  WBTouchView.h
//  WhiteboardTest
//
//  Created by Roman Gille on 19.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface A2RTouchView : UIView

- (void)setTouchBlock:(void(^)(NSSet* touches, CGPoint position))touchBlock;

@end
