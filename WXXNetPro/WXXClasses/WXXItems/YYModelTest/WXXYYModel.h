//
//  WXXYYModel.h
//  WXXNetPro
//
//  Created by WxxxYi on 2016/11/20.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXXYYModel : NSObject
@property (nonatomic ,strong) NSString * str1;
@property (nonatomic ,strong) NSString * str2;
@property (nonatomic ,strong) NSArray * arr1;
@property (nonatomic ,copy) NSMutableArray *arr2;
@property (nonatomic ,strong) NSDictionary *dic1 ;
@property (nonatomic ,strong) NSDictionary *dic2;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *nameID;
@property NSInteger age;


@end
