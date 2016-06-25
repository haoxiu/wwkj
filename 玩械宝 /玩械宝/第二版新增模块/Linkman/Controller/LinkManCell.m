//
//  LinkManCell.m
//  玩械宝
//
//  Created by wawa on 16/5/11.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "LinkManCell.h"
#import "FriendInfoModel.h"

@implementation LinkManCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView1.layer.cornerRadius = 20;
    self.imageView1.layer.masksToBounds = YES;
}

-(void)setModel:(FriendInfoModel *)model
{
    _model=model;
    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Key,model.hdimg]] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
    
    if ([model.nickname isEqualToString:@""])
    {
        if ([model.remark isEqualToString:@""])
        {
            NSString *originTel = [NSString stringWithFormat:@"%@",model.Friend];
            //   隐藏手机号中间四位数
            NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            _label1.text = tel;
        }
        else
        {
            _label1.text = model.remark;
        }
     }else
      {
        _label1.text=model.nickname;
      }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
