//
//  StarShop.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-11.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "StarShop.h"
NSString *const kNameKey = @"kNameKey";
NSString *const kAddressKey = @"kAddressKey";
NSString *const kbIdKey = @"kbIdKey";
@implementation StarShop

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:kNameKey];
    [aCoder encodeObject:self.address forKey:kAddressKey];
    [aCoder encodeObject:self.business_id forKey:kbIdKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self != nil){
        _name = [aDecoder decodeObjectForKey:kNameKey];
        _address = [aDecoder decodeObjectForKey:kAddressKey];
        _business_id = [aDecoder decodeObjectForKey:kbIdKey];
    }
    return self;
}
@end
