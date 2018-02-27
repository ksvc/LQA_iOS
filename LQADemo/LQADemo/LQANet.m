//
//  LQANet.m
//  LQADemo
//
//  Created by yuyang on 2018/1/15.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "LQANet.h"
#import <MJExtension/MJExtension.h>
@implementation LQANetModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return@{@"signalingTimestamp": @"X-KSC-SignalingTimestamp",
            @"requestSignaling" : @"X-KSC-RequestSignaling"};
}
@end

@implementation LQANet
+ (void)GET:(NSString *_Nullable)path param:(NSDictionary *_Nullable)param modelClass:(Class _Nullable ) modelClass success:(void (^_Nullable)(id _Nullable))success failure:(void (^_Nonnull)(NSError * _Nonnull))failure
{
    
    NSString * str = [NSString stringWithFormat:@"%@?%@", path,[self formatRequestParam:param]];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *dstUrl = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:dstUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if (!error){
            if ([response isKindOfClass:[NSHTTPURLResponse class]]){
                NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                if (statusCode != 200){
                    
                    id errVal = @(statusCode);
                    
                    if (data){
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        
                        if ([dict valueForKey:@"Error"]){
                            errVal = [[dict valueForKey:@"Error"] valueForKey:@"Message"];
                        }
                        
                    }
                    
                    NSError *error  = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey:errVal}];
                    if (failure){
                        failure(error);
                    }
                }else{
                    if (success){
                        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        
                        success(dict);
                    }
                }
            }
            
        }else{
            if (failure){
                failure(error);
            }
        }
        
    }] resume];
    
}

+ (void)POST:(NSString *_Nullable)path header:(NSDictionary *)header  param:(NSDictionary *_Nullable)param  modelClass:(Class _Nullable ) modelClass  success:(void (^)(id _Nullable))success
     failure:(void (^_Nullable)(NSError * _Nonnull))failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *dstUrl = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dstUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        request.HTTPMethod = @"POST";
        [header.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *strJson = nil;
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (!jsonData) {
            NSLog(@"Got an error: %@", error);
            NSAssert(0, @"invalid param");
        } else {
            strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        request.HTTPBody   = jsonData;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //
            if (!error){
                if ([response isKindOfClass:[NSHTTPURLResponse class]]){
                    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                    
                    if (statusCode != 200){
                        
                        id errVal = @(statusCode);
                        
                        if (data){
                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                            
                            if ([dict valueForKey:@"Error"]){
                                errVal = [[dict valueForKey:@"Error"] valueForKey:@"Message"];
                            }
                            
                        }
                        
                        NSError *error  = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey:errVal}];
                        if (failure){
                            failure(error);
                        }
                    }else{
                        if (success){
                            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                            if ([dict objectForKey:@"data"]) {
                                NSDictionary *data = [dict objectForKey:@"data"];
                                id model = [self modelConversionClass:modelClass :data];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    success(model);
                                });
                                
                            }
                            else
                            {
                                success(dict);
                            }
                            
                        }
                    }
                }
                
            }else{
                if (failure){
                    failure(error);
                }
            }
        }] resume];
        
    });
    
    
}


+ (id)modelConversionClass:(Class) modelClass :(NSDictionary *)data;
{
    id model = [modelClass  mj_objectWithKeyValues:data];
    
    return model;
}
+ (NSString *)formatRequestParam:(NSDictionary *)param
{
    NSMutableString *str = [[NSMutableString alloc] init];
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@=%@&", key, obj];
    }];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    return  [str stringByTrimmingCharactersInSet:characterSet];
}


@end
