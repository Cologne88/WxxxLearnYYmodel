//
//  WXXCalcuter.m
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/7.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//

#import "WXXCalcuter.h"

@implementation WXXCalcuter

- (WXXCalcuterBlock)add {
    
    return ^(float inputNum){
        
        self.result +=inputNum;
        return self;
    };
}

- (WXXCalcuterBlock)sub {
    return ^(float inputNum){
        self.result-=inputNum;
        return self;
    };
}

- (WXXCalcuterBlock)muti {
    return ^(float inputNum){
        self.result *= inputNum;
        return self;
    };
}

- (WXXCalcuterBlock)divide {
    return ^(float inputNum) {
        self.result /=inputNum;
        return  self;
    };
}


@end
