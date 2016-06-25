//
//  MessageCell.m
//  玩械宝
//
//  Created by Stone袁 on 15/12/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _ctreatSubview];
    }
    
    
    return self;


}


- (void)_ctreatSubview{
    
    /*
     
     此处创建子视图,没有设置frame,是因为,视图的frame需要根据数据才能确定(聊天信息的多少)
     此方法,在调用时,还没有数据,注意方法调用的顺序
     
     
     */
    
    //背景视图
    _bgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_bgImage];
    
    //聊天信息
    _lable = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lable];
    
    _lable.font = [UIFont systemFontOfSize:16];
    _lable.numberOfLines = 0; //自动换行
    
    //用户头像
    userimage = [[UIImageView alloc] initWithFrame:CGRectZero];
   
    // 设置圆角
    userimage.layer.cornerRadius = 20;
    
    [self.contentView addSubview:userimage];

    //取消选中效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    

}

//外部传递数据时调用的方法(set方法)
- (void)setMessage:(Message *)message{
    
    if (_message != message) {
        
        _message = message;
    }
    
    [self setNeedsLayout];
    
    
}

//给子视图布局的方法

/*

 1.给子视图填充数据
 2.布局子视图,设置子视图的frame
 
 */
- (void)layoutSubviews{
    
    //一定要去调用父类的方法,不然分割线会出现问题
    [super layoutSubviews];
    
    UIImage *image = [UIImage imageNamed:_message.icon]; //用户头像
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    userimage.image = image;
    // 设置圆角
    userimage.layer.masksToBounds = YES;

    userimage.layer.cornerRadius = 20;
    
    //2.计算聊天信息所占用的空间大小
    //此方法会显示警告,因为此方法在ios7中已不建议使用(但仍可以使用)
    CGSize size = [_message.content sizeWithFont:[UIFont systemFontOfSize:16]
                               constrainedToSize:CGSizeMake(width - 100, 9999)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    //3.根据求得的大小设置lable的高度
    _lable.text = _message.content;
    
    //背景视图
    UIImage *img1 = [UIImage imageNamed:@"chatfrom_bg_normal.png"]; //绿色背景
    UIImage *img2 = [UIImage imageNamed:@"chatto_bg_normal.png"];  //白色 自己
    
    UIImage *bgImg = _message.isSelf ?img2:img1;
    
    
    bgImg = [bgImg stretchableImageWithLeftCapWidth:bgImg.size.width * .5 topCapHeight:bgImg.size.height * .7];
    
    _bgImage.image = bgImg;
    
    
    //布局子视图 需判断消息是否为自己发送
    if (_message.isSelf) {
        
        userimage.frame = CGRectMake(width - 50, 10, 40, 40);
        
        _bgImage.frame = CGRectMake(20, 10, size.width + 30, size.height + 30);
        _lable.frame = CGRectMake(30, 20, size.width, size.height);
        
    }else{
        
        userimage.frame = CGRectMake(10, 10, 40, 40);
        _bgImage.frame = CGRectMake(60, 10, size.width + 30, size.height + 35);
        _lable.frame = CGRectMake(80, 20, size.width, size.height);
        
    }
    
    
}

@end
