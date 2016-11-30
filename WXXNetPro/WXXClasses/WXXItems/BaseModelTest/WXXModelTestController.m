//
//  WXXModelTestController.m
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/22.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXModelTestController.h"
#import "WXXModelTest.h"
#import "YYModel.h"


@interface WXXModelTestController ()

@end

@implementation WXXModelTestController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = @{@"str1":@"2",@"str2":@"3",@"dic1":@{@"arr2":@[@"aa",@"vvv",@"bbb"]},@"arr1":@[@"333",@"4444",@"5555"]
                          ,@"arr2":@[@"aa",@"bb"]};
    
    WXXModelTest * model =[[WXXModelTest alloc] initWithDic:dic];
    NSLog(@"%@",[model description]);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
