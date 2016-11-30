//
//  WXXCacuterController.h
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/7.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct example {
    int* aPint;
    double  aDouble;
    char *aString;
    int  anInt;
    BOOL isMan;
    struct example *next;
} Example;


@interface WXXCacuterController : UIViewController
@property (nonatomic ,strong) NSArray * arr1;
@property (nonatomic ,strong) NSString * str1;
@property (nonatomic ,strong) NSArray * arr2;
@property (nonatomic ,strong) NSString * str2;
@property (nonatomic ,assign) Example example;

@end
