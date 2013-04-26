//
//  A2RAccelerationView.m
//  Addicted2Random
//
//  Created by Roman Gille on 26.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RAccelerationView.h"

@interface A2RAccelerationView() <UIAccelerometerDelegate> {
    UIAccelerometer *_accelerometer;
    UIAcceleration *_lastAcceleration;
    NSMutableArray *_values;
}

@end

@implementation A2RAccelerationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDelegate:(id<A2RAccelerationViewDelegate>)delegate {
    if (delegate == nil) {
        _accelerometer.delegate = nil;
        _accelerometer = nil;
    }
    else {
        _accelerometer = [UIAccelerometer sharedAccelerometer];
        _accelerometer.updateInterval = .03f;
        _accelerometer.delegate = self;
        if (_values == nil) {
            _values = [NSMutableArray array];
        }
    }
    
    _delegate = delegate;
}

- (void)dealloc {
    _accelerometer.delegate = nil;
    _accelerometer = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGPoint startPoint = CGPointMake((self.frame.size.width / 2), (self.frame.size.height / 4));
    CGPoint currentPoint = startPoint;
    
    for (int i = 0; i < _values.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:currentPoint];
        [path setLineWidth: 2.f];
        [[UIColor colorWithRed:1.f/255.f green:1.f/255.f blue:1.f/255.f alpha:1.f / (200 / MAX(200-i, 0))] set];
        NSNumber *value = _values[_values.count - i - 1];
        CGPoint point = CGPointMake(startPoint.x + (value.floatValue * 10), startPoint.y + (i * 2));
        [path addLineToPoint: point];
        [path stroke];
        currentPoint = point;
        if (point.y > self.frame.size.height - 40)
            break;
    }

}


#pragma mark UIAccelerometer Delegate Methods

- (void)accelerometer:(UIAccelerometer *)meter didAccelerate:(UIAcceleration *)acceleration {
    if (_active) {
        //NSLog(@"Acceleration x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
        
        if(_lastAcceleration != nil) {
            // sqrt((B[0] - A[0])² + (B[1] - A[1])² + (B[2] - A[2])²)
            CGFloat x = pow(acceleration.x - _lastAcceleration.x, 2.f);
            CGFloat y = pow(acceleration.y - _lastAcceleration.y, 2.f);
            CGFloat z = pow(acceleration.z - _lastAcceleration.z, 2.f);
            CGFloat spinValue = sqrt(x + y + z);
            [_values addObject:[NSNumber numberWithFloat:spinValue]];
            [self setNeedsDisplay];
            // NSLog(@"spinValue: %f", spinValue);
            
            if ([_delegate respondsToSelector:@selector(valueDidChange:)]) {
                [_delegate valueDidChange:spinValue];
            }
        }
        _lastAcceleration = acceleration;
    }
}

@end
