//
//  DropDownChooseProtocol.h
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//  Modified by 钱思聪 on 14-7-5
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DropDownChooseDelegate <NSObject>
-(void)didInSelect:(NSInteger)section index:(NSInteger) index mIndex:(NSInteger) mIndex TableType:(int) type;
@optional

-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index;
@end

@protocol DropDownChooseDataSource <NSObject>
-(NSInteger)numberOfSections:(int) type;
-(NSInteger)numberOfRowsInSection:(NSInteger)section mIndex:(NSInteger) mIndex TableType:(int) type;
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index mIndex:(NSInteger) mIndex TableType:(int) type;
-(NSInteger)defaultShowSection:(NSInteger)section;

@end



