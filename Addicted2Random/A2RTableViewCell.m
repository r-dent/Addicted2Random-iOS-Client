//
//  A2RTableViewCell.m
//  Addicted2Random
//
//  Created by Roman Gille on 20.05.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RTableViewCell.h"

@implementation A2RTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.style = A2RTableViewCellStyleDisclosure;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 57.f;
}

+ (NSString *)identifier {
    return @"A2RTableViewCellIdentifier";
}

- (void)setStyle:(A2RTableViewCellStyle)style {
    if (_style != style) {
        switch (style) {
            case A2RTableViewCellStyleLoading: {
                UIActivityIndicatorView *throbber = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [throbber startAnimating];
                self.accessoryView = throbber;
                break;
            }
            case A2RTableViewCellStyleDisclosure: {
                UIImageView* arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure"]];
                self.accessoryView = arrowView;
                break;
            }
                
            default:
                break;
        }
    }
}

@end
