//
//  WXXModelTest.h
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/22.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXBaseModel.h"

@interface WXXModelTest : WXXBaseModel
@property (nonatomic ,strong) NSString * str1;
@property (nonatomic ,strong) NSString * str2;
@property (nonatomic ,strong) NSArray * arr1;
@property (nonatomic ,copy) NSMutableArray * arr2;
@property (nonatomic ,strong) NSDictionary *dic1 ;
@property (nonatomic ,strong) NSDictionary *dic2;
@end
