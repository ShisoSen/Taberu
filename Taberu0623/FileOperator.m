//
//  FileOperator.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-11.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "FileOperator.h"

@implementation FileOperator

+(NSMutableArray *)loadingDataByName:(NSString *)fileName{
    NSMutableArray *reArr;
    
    //获取路径和保存文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* fn = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:fn]) {
        reArr = [NSKeyedUnarchiver unarchiveObjectWithFile:fn];
    }else{
        reArr = nil;
    }
    
    return reArr;
}

+(NSInteger)saveDstaByName:(NSMutableArray *)obs fileName:(NSString *)fileName{
    //获取路径和保存文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* fn = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    return [NSKeyedArchiver archiveRootObject:obs toFile:fn];
}

#pragma mark starShop
+(NSInteger)deleteFile:(NSString *)fileName{
    //获取路径和保存文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* fn = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:fn]) {
        if ([fileManager isDeletableFileAtPath:fn]) {
            [fileManager removeItemAtPath:fn error:nil];
            return 1;
        }
    }else{
        return -1;
    }
    return 0;
}
+(NSInteger)containObject:(StarShop *)ob fileName:(NSString *)fileName{
    NSMutableArray *reArr = [FileOperator loadingDataByName:fileName];
    if (reArr==nil) {
        return -1;
    }
    for (StarShop *e in reArr) {
        if ([e.business_id isEqualToString:ob.business_id]) {
            return 1;
        }
    }
    return 0;
}
+(NSInteger)addObject:(StarShop *)ob fileName:(NSString *)fileName{
    if (ob==nil||ob.business_id == nil) {
        return -1;
    }
    NSMutableArray __autoreleasing *reArr = [FileOperator loadingDataByName:fileName];
    if (reArr==nil) {
        reArr = [NSMutableArray array];
    }
    [reArr addObject:ob];
    [FileOperator saveDstaByName:reArr fileName:fileName];
    return [reArr count];
}

+(NSInteger)deleteObject:(StarShop *)ob fileName:(NSString *)fileName{
    if ([FileOperator containObject:ob fileName:fileName]) {
        NSMutableArray *reArr = [FileOperator loadingDataByName:fileName];
        int i = 0;
        for (StarShop *e in reArr) {
            if ([e.business_id isEqualToString:ob.business_id]) {
                [reArr removeObjectAtIndex:i];
                break;
            }
            i++;
        }
        [FileOperator saveDstaByName:reArr fileName:fileName];
        return [reArr count];
    }else{
        return -1;
    }
}
@end
