//
//  WXXTabBarController.m
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/7.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXTabBarController.h"
#import "WXXNavigationController.h"
#import "WXXCacuterController.h"
#import "WXXModelTestController.h"
#import "WXXYYmodelController.h"
#import "WXXListController.h"

@interface WXXTabBarController ()<UITabBarDelegate>
@property (nonatomic ,strong) WXXCacuterController *vc;
@property (nonatomic,strong) WXXModelTestController *vc2;
@property (nonatomic,strong)  WXXListController *vc3;

@end

@implementation WXXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
}

- (void)setupTabBar {
    _vc =[[WXXCacuterController alloc] init];
    [self addChildViewController:_vc normalImage:nil selectImage:nil title:@"王"];
    
    _vc2 =[[WXXModelTestController alloc] init];
    [self addChildViewController:_vc2 normalImage:nil selectImage:nil title:@"亦"];
    _vc3 =[[WXXListController alloc] init];
    [self addChildViewController:_vc3 normalImage:nil selectImage:nil title:@"梁"];
}
- (void)addChildViewController:(UIViewController *)childController
                   normalImage:(UIImage*) image
                   selectImage:(UIImage*) seleceImage
                         title:(NSString *) title{
    
    WXXNavigationController *nav = [[WXXNavigationController alloc] initWithRootViewController:childController];
    //图片不处理保持原状态
    nav.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [seleceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.title =title;
    childController.title =title;
    
    
    //选中时图标颜色
    //    self.tabBar.tintColor = [UIColor colorWithRed:197/255.0
    //                                            green:197/255.0
    //                                             blue:217/255.0 alpha:1];
    
    // 选中时字体颜色
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:26/255.0
                                                                                            green:26/255.0
                                                                                             blue:26/255.0
                                                                                            alpha:1],
                                             NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:1.0]} forState:UIControlStateSelected];
    
    //tabbar背景色
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:233/255.0
                                                           green:233/255.0
                                                            blue:233/255.0 alpha:1]];
    
    //    nav.tabBarItem.badgeValue =@"111";
    
    [self addChildViewController: nav];

    
}
@end
