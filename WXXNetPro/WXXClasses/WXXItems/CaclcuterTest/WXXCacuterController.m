//
//  WXXCacuterController.m
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/7.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXCacuterController.h"
#import "WXXCalcuter.h"
#import <objc/objc-runtime.h>

#import "YYModel.h"
#import "WXXModelTest.h"

#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
@interface WXXCacuterController ()

@end

@implementation WXXCacuterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self StartCaluter];
//    NSLog(@"%@,%@",[self class],object_getClass(self));
//    
//    NSLog( @"md5 : %@",[self md5:@"aaa"]);
//    
//    NSArray *arr_1 = [self filterPropertys];
//    NSLog(@"%@",arr_1);
    
     objc_property_t property = class_getProperty([WXXCacuterController class], "arr1");
    YYClassPropertyInfo *propertyInfo = [[YYClassPropertyInfo alloc] initWithProperty:
                                        property];
    NSLog(@"%@",propertyInfo.typeEncoding);
    
    
    
}

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

- (void)setupView {
    
    self.view.backgroundColor =[UIColor whiteColor];
    //2016-09-20 19:24:36.942 WXXNetPro[12300:530356] md5 : 47bce5c74f589f4867dbd57e9ca9f808

}


- (NSString *)md5:(NSString *)str

{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
}

- (void)StartCaluter {
    
    WXXCalcuter * CA = [[WXXCalcuter alloc] init];
    float re =  CA.add(1).add(2).add(3).result;
    float re1 = CA.sub(1).muti(5).result;
    float re2 = CA.divide (5).result;
    NSLog(@"%f",re);
    NSLog(@"%f",re1);
    NSLog(@"%f",re2);
    
}

@end
