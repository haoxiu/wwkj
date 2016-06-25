//
//  BaseModel.h
//  WXMovie
//
//  Created by seven on 15/2/10.
//  Copyright (c) . All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    概述：“自动”设置赋值
    思考：
        (1)model和JSON[dic]映射关系
        (2)JSON的key就是属性名称，例外：JSON：id
        (3)例如：JSON：image  hehe  setHehe:  setImage:
                model：image，(setImage:)
            通过JSON给定的key ，生成字符串: @"setImage:"
        (4)生成setter方法，生成SEL变量(指向一个setter方法)
        (5)根据生成的setter方法设置model属性的值
 */

@interface BaseModel : NSObject

- (id)initContentWithDic:(NSDictionary *)jsonDic;
- (void)setAttributes:(NSDictionary *)jsonDic;
- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic;

@end
