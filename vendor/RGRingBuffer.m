//
//  RGRingBuffer.m
//  Addicted2Random
//
//  Created by Roman Gille on 23.05.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "RGRingBuffer.h"

@interface RGRingBuffer()

@property (nonatomic, strong) NSMutableArray *buffer;
@property (nonatomic, assign) int start;
@property (nonatomic, assign) int end;
@property (nonatomic, assign) int pointer;
@property (nonatomic, assign) int capacity;

@end

@implementation RGRingBuffer

- (id)initWithCapacity:(int)capacity {
    self = [super init];
    self.buffer = [NSMutableArray arrayWithCapacity:capacity];
    self.start = self.end = self.pointer = 0;
    self.capacity = capacity;
    return self;
}

- (void)addObject:(id)object {
    _buffer[_end] = object;
    _end = (_end + 1) % _capacity;
    if (self.size >= _capacity -1) {
        _start = (_start + 1) % _capacity;
    }
}

- (id)objectAtIndex:(int)index {
    if (index < self.size) {
        return _buffer[(_start + index) % _capacity];
    }
    return nil;
}

- (void)setObject:(id)object atIndex:(int)index {
    if (index < self.size) {
        _buffer[(_start + index) % _capacity] = object;
    }
}

- (int)size {
    return (_end >= _start) ? _end - _start : _capacity - _start + _end;
}

- (id)first {
    _pointer = _start;
    return _buffer[_pointer];
}

- (id)next {
    _pointer = ((_pointer + 1) % _capacity) + _start;
    return _buffer[_pointer];
}

- (id)last {
    _pointer = _end -1;
    return _buffer[_pointer];
}

@end
