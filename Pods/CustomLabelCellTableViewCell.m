//
//  CustomLabelCellTableViewCell.m
//  app
//
//  Created by Henry Savit on 10/19/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "CustomLabelCellTableViewCell.h"

@implementation CustomLabelCellTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _heading = [[UILabel alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize expectedSize = [_heading.text boundingRectWithSize:CGSizeMake(151, 104) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: _heading.font} context:nil].size;
    _heading.frame = CGRectMake(70, 8, 230, expectedSize.height);
    [self addSubview:_heading];
}

@end
