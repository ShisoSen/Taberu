//
//  FileOperator.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-11.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StarShop.h"
@interface FileOperator : NSObject

+(NSMutableArray *)loadingDataByName:(NSString *)fileName;
+(NSInteger)saveDstaByName:(NSMutableArray *)obs fileName:(NSString *)fileName;
+(NSInteger)containObject:(StarShop *)ob fileName:(NSString *)fileName;
+(NSInteger)addObject:(StarShop *)ob fileName:(NSString *)fileName;
+(NSInteger)deleteObject:(StarShop *)ob fileName:(NSString *)fileName;
+(NSInteger)deleteFile:(NSString *)fileName;
@end
