//
//  A2RAccelerationView.m
//  Addicted2Random
//
//  Created by Roman Gille on 26.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RAccelerationView.h"

#import "RGRingBuffer.h"

typedef enum {
    A2RAccelerationComponentX = 0,
    A2RAccelerationComponentY,
    A2RAccelerationComponentZ
    } A2RAccelerationComponent;

@interface A2RAccelerationView() <UIAccelerometerDelegate> {
    UIAccelerometer *_accelerometer;
    UIAcceleration *_lastAcceleration;
    RGRingBuffer *_values;
    CGFloat _sourceY;
}

@property (nonatomic, strong) UIImageView *move;
@property (nonatomic, strong) UIImageView *your;
@property (nonatomic, strong) UIImageView *phone;

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
    //self.backgroundColor = [UIColor blackColor];
    _sourceY = 44;
    self.move = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word_move"]];
    _move.center = CGPointMake(self.frame.size.width / 4, _sourceY);
    [self addSubview:_move];
    
    self.your = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word_your"]];
    _your.center = CGPointMake(self.frame.size.width / 4 * 2, _sourceY);
    [self addSubview:_your];
    
    self.phone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word_phone"]];
    _phone.center = CGPointMake(self.frame.size.width / 4 * 3, _sourceY);
    [self addSubview:_phone];
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
            _values = [[RGRingBuffer alloc] initWithCapacity:300];
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
    CGFloat y = _sourceY;
    CGPoint startPoint = CGPointMake((self.frame.size.width / 4), y);
    [self drawAccelerationsComponent:A2RAccelerationComponentX withStartingPoint:startPoint andColor:A2R_RED];
    
    startPoint = CGPointMake((self.frame.size.width / 4 * 2), y);
    [self drawAccelerationsComponent:A2RAccelerationComponentY withStartingPoint:startPoint andColor:A2R_BLUE];
    
    startPoint = CGPointMake((self.frame.size.width / 4 * 3), y);
    [self drawAccelerationsComponent:A2RAccelerationComponentZ withStartingPoint:startPoint andColor:A2R_YELLOW];

}

- (void)drawAccelerationsComponent:(A2RAccelerationComponent)component withStartingPoint:(CGPoint)startingPoint andColor:(UIColor*)color {
    CGPoint currentPoint = startingPoint;
    [color set];
    BOOL flowUp = startingPoint.y >= self.frame.size.height / 2;
    CGFloat maxLength = flowUp ? startingPoint.y : self.frame.size.height - startingPoint.y;
    
    for (int i = 0; i < _values.size; i++) {
        CGFloat componentValue = [self valueFromAcceleration:[_values objectAtIndex:_values.size - i - 1] component:component];
        
        CGPoint point = CGPointMake(startingPoint.x + (componentValue * 10), startingPoint.y + ((flowUp ? -i : i) * 2));
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:currentPoint];
        if (point.y < maxLength - 50) {
            [path setLineWidth: 6.f - MIN(5.f, i * .05f)];
        }
        else {
            [path setLineWidth: .02f * MAX(0, maxLength - point.y)];
        }
        [path addLineToPoint: point];
        [path stroke];
        
        currentPoint = point;
        
        if (flowUp && point.y < 0)
            break;
        if (!flowUp && point.y > self.frame.size.height)
            break;
    }
    
    CGFloat componentValue = _values.size ? [self valueFromAcceleration:[_values objectAtIndex:_values.size - 1] component:component] : 0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth: 0.f];
    [path addArcWithCenter:startingPoint radius:componentValue * 5 + 10 startAngle:0.f endAngle:M_PI * 2 clockwise:YES];
    [path fill];
    
}

- (CGFloat)valueFromAcceleration:(UIAcceleration*)acceleration component:(A2RAccelerationComponent)component {
    switch (component) {
        case A2RAccelerationComponentY:
            return acceleration.y;
            break;
        case A2RAccelerationComponentZ:
            return acceleration.z;
            break;
            
        default:
            return acceleration.x;
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
            
            _move.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + acceleration.x / 2, 1 + acceleration.x / 2);
            _your.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + acceleration.y / 2, 1 + acceleration.y / 2);
            _phone.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + acceleration.z / 2, 1 + acceleration.z / 2);
            
            if ([_delegate respondsToSelector:@selector(valueDidChange:)]) {
                [_delegate valueDidChange:spinValue];
            }
        }
        _lastAcceleration = acceleration;
    }
}

@end
