//
//  WXXYYmodelController.m
//  WXXNetPro
//
//  Created by WxxxYi on 2016/11/20.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXYYmodelController.h"
#import <YYModel/YYModel.h>
#import "WXXYYModel.h"
@interface WXXYYmodelController ()

@end

@implementation WXXYYmodelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = @{@"str1":@"2",@"str2":@"3",
                    @"dic1":@{@"arr2":@[@"aa",@"vvv",@"bbb"]},
                          @"arr1":@[@"333",@"4444",@"5555"],
                          @"arr2":@[@"aa",@"bb"],
                          @"n":@"名字1",
                          @"a":@"21",
                          @"ext":@{@"desc":@"Test Of Description"},
                          @"ID":@10001};
    
    //dic->model
    WXXYYModel *model = [WXXYYModel yy_modelWithDictionary:dic];

    NSLog(@"%@",model.arr1);
    //model->json
    NSData *json = [model yy_modelToJSONData];
    //json->model
    WXXYYModel *model2 =[WXXYYModel yy_modelWithJSON:json];
    NSLog(@"%@",model2.name);
    
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
