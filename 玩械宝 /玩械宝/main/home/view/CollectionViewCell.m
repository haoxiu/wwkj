//
//  CollectionViewCell.m
//  玩械宝
//
//  Created by Stone袁 on 16/2/23.
//  Copyright (c) 2016年 zgcainiao. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h" //SDWebImage


@interface CollectionViewCell()

@property (nonatomic, strong) UIImageView *imgVew;

@end

@implementation CollectionViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //创建子视图
        _imgVew = [[UIImageView alloc] initWithFrame:self.bounds];
        
        //设置图片等比例缩放
//        _imgVew.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_imgVew];
        
}
    return self;
}

- (void)setImgurl:(NSString *)imgurl{


    _imgurl = imgurl;
    
//    [_imgVew sd_setImageWithURL:[NSURL URLWithString:imgurl]];
     [_imgVew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://eswjdg.com/%@",imgurl]] placeholderImage:[UIImage imageNamed:@"waji"]];

}


@end
