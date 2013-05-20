//
//  A2RAccelerationView.m
//  Addicted2Random
//
//  Created by Roman Gille on 26.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RAccelerationView.h"

typedef enum {
    A2RAccelerationComponentX = 0,
    A2RAccelerationComponentY,
    A2RAccelerationComponentZ
    } A2RAccelerationComponent;

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
        [self initValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initValues];
    return self;
}

- (void)initValues {
    self.backgroundColor = [UIColor blackColor];
    
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
    CGPoint startPoint = CGPointMake((self.frame.size.width / 4), (self.frame.size.height / 4));
    [self drawAccelerationsComponent:A2RAccelerationComponentX withStartingPoint:startPoint andColor:A2R_YELLOW];
    
    startPoint = CGPointMake((self.frame.size.width / 4 * 2), (self.frame.size.height / 4));
    [self drawAccelerationsComponent:A2RAccelerationComponentY withStartingPoint:startPoint andColor:A2R_BLUE];
    
    startPoint = CGPointMake((self.frame.size.width / 4 * 3), (self.frame.size.height / 4));
    [self drawAccelerationsComponent:A2RAccelerationComponentZ withStartingPoint:startPoint andColor:A2R_RED];

}

- (void)drawAccelerationsComponent:(A2RAccelerationComponent)component withStartingPoint:(CGPoint)startingPoint andColor:(UIColor*)color {
    CGPoint currentPoint = startingPoint;
    [color set];
    
    for (int i = 0; i < _values.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:currentPoint];
        [path setLineWidth: 6.f - MIN(5.f, i * .05f)];
        UIAcceleration *value = _values[_values.count - i - 1];
        CGFloat componentValue;
        switch (component) {
            case A2RAccelerationComponentY:
                componentValue = value.y;
                break;
            case A2RAccelerationComponentZ:
                componentValue = value.z;
                break;
                
            default:
                componentValue = value.x;
                break;
        }
        //CGPoint point = CGPointMake(startingPoint.x + (value.x * 10 * (i % 2 == 0 ? 1 : -1)), startingPoint.y + (i * 2));
        CGPoint point = CGPointMake(startingPoint.x + (componentValue * 10), startingPoint.y + (i * 2));
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
            [_values addObject:acceleration];
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
