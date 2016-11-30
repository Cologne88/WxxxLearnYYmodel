//
//  WXXCalcuter.h
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/7.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//
@class WXXCalcuter;
#import <Foundation/Foundation.h>
typedef WXXCalcuter*  (^WXXCalcuterBlock)(float);

@interface WXXCalcuter : NSObject

@property (nonatomic,assign) float result;
@property (nonatomic ,copy) WXXCalcuterBlock add;
@property (nonatomic ,copy) WXXCalcuterBlock sub;
@property (nonatomic ,copy) WXXCalcuterBlock muti;
@property (nonatomic ,copy) WXXCalcuterBlock divide;
@end
