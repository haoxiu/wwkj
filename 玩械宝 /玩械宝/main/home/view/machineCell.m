//
//  machineCell.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "machineCell.h"
#import "UIImageView+WebCache.h"

@implementation machineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(MachineModel *)model {
    if (_model != model) {
        
        _model = model;
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://waji.zgcainiao.com/%@",_model.picture[0][@"image"]]]];
//    if (data != nil) {
    

//        [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://waji.zgcainiao.com/%@",_model.picture[0][@"image"]]] options:SDWebImageLowPriority];
    if ([_model.picture[0][@"image"] isEqualToString:@"0"]) {
        
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"http://pic39.nipic.com/20140323/18181467_151437266161_2.jpg"]];
    }
    else {  [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://eswjdg.com/%@",_model.picture[0][@"image"]]] placeholderImage:[UIImage imageNamed:@"waji"]];
    }

//    }
    _brandLable.text = [NSString stringWithFormat:@"%@%@",_model.brand,_model.version];
    _priceLabel.text = [NSString stringWithFormat:@"价格 %@万", _model.price];
    _hoursLabel.text = [NSString stringWithFormat:@"小时数%@",_model.worktime];
    if (_hideSth) {
        
        _priceLabel.hidden = YES;
        _hoursLabel.hidden = YES;
        _height1.constant = self.contentView.height-10;
    }
    _inputtimeLabel.text = _model.inputtime;
    _placeLabel.text = _model.place;
    _placeLabel.adjustsFontSizeToFitWidth = YES;
}
@end
