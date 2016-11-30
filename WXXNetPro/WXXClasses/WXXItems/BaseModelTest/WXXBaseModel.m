//
//  WXXBaseModel.m
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/22.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXBaseModel.h"
#import "objc/objc-runtime.h"
@implementation WXXBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!dic  ||![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (self =[super init]) {

        for (NSString *key in [dic allKeys] ) {
            id value = dic[key];
            
            if ([value isKindOfClass:[NSArray class]]
                ||[value isKindOfClass:[NSDictionary class]]
                    ) {
                [self setValue:value forKeyPath:key];
            }
            else if ([value isKindOfClass:[NSNull class]] ) {
                NSLog(@"null,KVC Start ");
                [self setValue:nil forKeyPath:key];
                
            }
            else {
                //数字等用 nsstring
                [self setValue:[NSString stringWithFormat:@"%@",value] forKeyPath:key];
            }
        }
    }
    return self;
    
}
#pragma mark 打印出内部信息
- (NSString *)description
{
    NSMutableString* text = [NSMutableString stringWithFormat:@"<%@> \n", [self class]];
    NSArray* properties = [self filterPropertys];
    
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* key = (NSString*)obj;
        id value = [self valueForKey:key];
        NSString* valueDescription = (value)?[value description]:@"(null)";
        
        if ( ![value respondsToSelector:@selector(count)] && [valueDescription length]>60  ) {
            valueDescription = [NSString stringWithFormat:@"%@...", [valueDescription substringToIndex:59]];
        }
        valueDescription = [valueDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
        [text appendFormat:@"   [%@]: %@\n", key, valueDescription];
    }];
    
    [text appendFormat:@"</%@>", [self class]];;
    return text;
    
}

#pragma runtime 获取所有的属性
- (NSArray *)filterPropertys {
    
    NSMutableArray * mutabArray = [NSMutableArray array];
    unsigned int  outcount;
    objc_property_t *propertys = class_copyPropertyList([self class], &outcount);
    for (int i =0; i<outcount; i++) {
        objc_property_t property = propertys[i];
        const char* char_f =property_getName(property);
        NSString * propertyName =  [NSString stringWithUTF8String:char_f];
        //        const char * char_N = property_getAttributes(property);
        [mutabArray addObject:propertyName];
        
        NSLog(@"name:%s",property_getName(property));
        NSLog(@"attributes:%s",property_getAttributes(property));
        
    }
    
    free(propertys);
    
    return mutabArray;
}

@end
