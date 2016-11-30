//
//  WXXListController.m
//  WXXNetPro
//
//  Created by WxxxYi on 2016/11/21.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXListController.h"
#import "WXXModelTestController.h"
#import "WXXYYmodelController.h"

@interface WXXListController ()
@property (nonatomic,strong) NSArray *lists;
@end

@implementation WXXListController
static NSString *const  aCell = @"acell";
- (NSArray *)lists{
    if (_lists==nil) {
        _lists =@[@"BaseModel使用",@"YYmodel使用",
                  @"",@"",@"",];
        
    }
    return _lists;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:aCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:aCell forIndexPath:indexPath];
    
    cell.textLabel.text = self.lists[indexPath.row];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0 &&indexPath.row ==0) {
        
        WXXModelTestController * FeedVC = [[WXXModelTestController alloc] init];
        FeedVC.title = self.lists[indexPath.row];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:FeedVC animated:YES ];
        self.hidesBottomBarWhenPushed=NO;
        
    }else if (indexPath.section ==0 &&indexPath.row ==1){
        WXXYYmodelController * FeedVC = [[WXXYYmodelController alloc] init];
        FeedVC.title = self.lists[indexPath.row];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:FeedVC animated:YES ];
        self.hidesBottomBarWhenPushed=NO;

    }

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
