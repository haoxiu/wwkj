//
//  CircleFriendsViewControllerCell.m
//  玩械宝
//
//  Created by wawa on 16/6/13.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "CircleFriendsViewControllerCell.h"
#import "CircleFriendsModel.h"

@implementation CircleFriendsViewControllerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImage.layer.cornerRadius = _headImage.frame.size.width/2;
    _headImage.layer.masksToBounds = YES;
}
-(void)setModel:(CircleFriendsModel *)model
{
    _model=model;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Key,model.hdimg]] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
    if ([model.nickname isEqualToString:@""])
    {
        if ([model.remark isEqualToString:@""])
        {
            _nickLabel.text = model.user_id;
        }
        else
        {
            _nickLabel.text = model.remark;
        }
    }else
    {
        _nickLabel.text=model.nickname;
    }
    _nowTime.text=model.fbtime;
    _contentLabel.text=model.content;
    _titleLabel.text=model.title;
    _priceLabel.text=[NSString stringWithFormat:@"价格:¥%@万",model.price];
    _priceLabel.textColor=[UIColor redColor];
    if ([model.usertime isEqualToString:@""])
    {
      _timeLabel.text=[NSString stringWithFormat:@"小时数:0"];
    }else
    {
      _timeLabel.text=[NSString stringWithFormat:@"小时数:%@",model.usertime];
    }
    _addressLabel.text=model.address;
    //将图片放在滚动视图上
    NSMutableArray * imgArr = model.images;
    
    _ScrollView.pagingEnabled = YES;
    _ScrollView.showsHorizontalScrollIndicator =YES;
    _ScrollView.showsVerticalScrollIndicator = NO;
    if (imgArr.count !=0)
    {
        for (int i = 0; i < imgArr.count; i++)
        {
            UIImageView *imageView  = [[UIImageView alloc]initWithFrame:[FlexBile frameIPONE5Frame:CGRectMake(i*80,0,70,70)]];

            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Keys,imgArr[i]]]];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            _ScrollView.contentSize =CGSizeMake((imgArr.count-1)*70*[FlexBile ratio], 70*[FlexBile ratio]);
            [_ScrollView addSubview:imageView];
            NSLog(@"%@%@",URL_Keys,imgArr[i]);
        }
    }
    else{
        _ScrollView.hidden=YES;

        }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
