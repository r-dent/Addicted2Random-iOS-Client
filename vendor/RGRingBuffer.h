//
//  RGRingBuffer.h
//  Addicted2Random
//
//  Created by Roman Gille on 23.05.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGRingBuffer : NSObject

@property (nonatomic,readonly) int size;

- (id)initWithCapacity:(int)capacity;
- (void)addObject:(id)object;
- (id)objectAtIndex:(int)index;
- (void)setObject:(id)object atIndex:(int)index;
- (id)first;
- (id)next;
- (id)last;

@end
