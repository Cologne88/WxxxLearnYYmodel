//
//  WXXSessionNetWorking.m
//  WXXNetPro
//
//  Created by WxxxYi on 16/9/7.
//  Copyright © 2016年 WxxxYi. All rights reserved.
//


#import "WXXSessionNetWorking.h"


@implementation WXXSessionNetWorking

+ (void)GET:(NSString *)url
     params:(NSDictionary *) params
    success: (WXXResponseSuccess)success
       fail: (WXXResponseFail)fail  {
    AFHTTPSessionManager *manager = [WXXSessionNetWorking managerWithBaseURL:nil sessionConfiguration:NO];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dic =[WXXSessionNetWorking responseConfiguration:responseObject];
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
    
}

+ (void)GET:(NSString *)url
    baseURL: baseUrl
     params:(NSDictionary *) params
    success: (WXXResponseSuccess)success
       fail: (WXXResponseFail)fail  {
    
    AFHTTPSessionManager *manager = [WXXSessionNetWorking managerWithBaseURL:baseUrl sessionConfiguration:NO];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        id dic = [WXXSessionNetWorking responseConfiguration:responseObject];
        
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}


+ (void)POST:(NSString *)url
      params:(NSDictionary *) params
     success: (WXXResponseSuccess) success
        fail: (WXXResponseFail)fail  {
    
    AFHTTPSessionManager *manager = [WXXSessionNetWorking managerWithBaseURL:nil sessionConfiguration:NO];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [WXXSessionNetWorking responseConfiguration:responseObject];
        
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];

    
}


+ (void)POST:(NSString *)url
    baseURL : baseUrl
      params:(NSDictionary *)params
     success:(WXXResponseSuccess)success
        fail:(WXXResponseFail)fail{
    
    AFHTTPSessionManager *manager = [WXXSessionNetWorking managerWithBaseURL:baseUrl sessionConfiguration:NO];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [WXXSessionNetWorking responseConfiguration:responseObject];
        
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];

}


+ (void)uploadWithURL: (NSString *)url
               params:(NSDictionary *)params
             fileData: (NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)filename
             mimeType:(NSString *)mimetype
             progress:(WXXProgress)progress
              success: (WXXResponseSuccess)success
                 fail: (WXXResponseFail)fail  {
    
    AFHTTPSessionManager *manager = [WXXSessionNetWorking managerWithBaseURL:nil sessionConfiguration:NO];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimetype];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [WXXSessionNetWorking responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];

    
}

+ (void)uploadWithURL: (NSString *)url
              baseURL: (NSString *)baseUrl
               params:(NSDictionary *)params
             fileData: (NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)filename
             mimeType:(NSString *)mimetype
             progress:(WXXProgress)progress
              success: (WXXResponseSuccess)success
                 fail: (WXXResponseFail)fail  {
    AFHTTPSessionManager *manager = [WXXSessionNetWorking managerWithBaseURL:baseUrl sessionConfiguration:YES];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimetype];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [WXXSessionNetWorking responseConfiguration:responseObject];
        
        success(task,dic);
        
        
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];

    
}

/**
 *  下载文件
 *
 *  @param url      请求网络路径
 *  @param fileURL  保存文件url
 *  @param progress 下载进度
 *  @param success  成功回调
 *  @param fail     失败回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */

+ (NSURLSessionDownloadTask *)downloadWithURL: (NSString*)url
                                  savePathURL:(NSURL *)fileURL
                                     progress:(WXXProgress) progress
                                      success:(void (^)(NSURLResponse *, NSURL *))success
                                         fail:(void (^)(NSError *))fail{
    AFHTTPSessionManager *manager = [self managerWithBaseURL:nil sessionConfiguration:YES];
    
    NSURL *urlpath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            fail(error);
        }else{
            
            success(response,filePath);
        }
    }];
    
    [downloadtask resume];
    
    return downloadtask;
    
}

#pragma mark - Private

+ (AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL  sessionConfiguration:(BOOL)isconfiguration{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =nil;
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    if (isconfiguration) {
        
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return manager;
}

+ (id)responseConfiguration:(id)responseObject{
    
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}


@end
