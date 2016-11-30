//
//  YYModel.h
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by ibireme on 15/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<YYModel/YYModel.h>)     //此宏传入一个你想引入文件的名称作为参数，如果该文件能够被引入则返回1，否则返回0。

//FOUNDATION_EXPORT 和#define 作用是一样的，使用第一种在检索字符串的时候可以用 ==  #define 需要使用isEqualToString 在效率上前者由于是基于地址的判断 速度会更快一些

FOUNDATION_EXPORT double YYModelVersionNumber;
FOUNDATION_EXPORT const unsigned char YYModelVersionString[];
#import <YYModel/NSObject+YYModel.h>
#import <YYModel/YYClassInfo.h>
#else
#import "NSObject+YYModel.h"
#import "YYClassInfo.h"
#endif
