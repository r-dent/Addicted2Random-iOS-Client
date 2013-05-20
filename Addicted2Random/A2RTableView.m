//
//  A2RTableView.m
//  Addicted2Random
//
//  Created by Roman Gille on 20.05.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RTableView.h"

@implementation A2RTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setupLayout];
    return self;
}

- (void)setupLayout {
    self.backgroundColor = [UIColor blackColor];
//    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
