//
//  ENMiscFetchNextCell.m
//  haodf
//
//  Created by zhaojun on 13-12-23.
//  Copyright (c) 2013年 All rights reserved.
//

#import "ENMiscFetchNextCell.h"
#define FETCH_NEXT_IDENTIFIER @"FetchNextCell"

@implementation ENMiscFetchNextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    UIImageView *background = (UIImageView *)self.backgroundView;
    [background setHighlighted:highlighted];
}

@end
