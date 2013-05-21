//
//  A2RTableViewCell.h
//  Addicted2Random
//
//  Created by Roman Gille on 20.05.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    A2RTableViewCellStyleDefault = 0,
    A2RTableViewCellStyleDisclosure,
    A2RTableViewCellStyleLoading
}A2RTableViewCellStyle;

@interface A2RTableViewCell : UITableViewCell

+ (CGFloat)cellHeight;
+ (NSString*)identifier;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (assign, nonatomic) A2RTableViewCellStyle style;

@end
