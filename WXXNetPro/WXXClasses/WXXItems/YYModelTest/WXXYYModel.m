//
//  WXXYYModel.m
//  WXXNetPro
//
//  Created by WxxxYi on 2016/11/20.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXYYModel.h"
#import <YYModel/YYModel.h>


@implementation WXXYYModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"name":@"n",
             @"age":@"a",
             @"desc":@"ext.desc",
             @"nameID":@[@"id",@"ID",@"name_id"]};
}
@end
