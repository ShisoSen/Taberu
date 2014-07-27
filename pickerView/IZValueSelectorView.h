//
//  IZValueSelectorView.h
//  Taberu0623
//
//  Created by Iman Zarrabian on 02/11/12.
//  Copyright (c) 2012 Iman Zarrabian. All rights reserved.
//  Modified by Sicong Qian on 14-7-8.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IZValueSelectorView;

@protocol IZValueSelectorViewDelegate <NSObject>

- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index;

@end

@protocol IZValueSelectorViewDataSource <NSObject>
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector;
- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger) index;
- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector;
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector;
- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector;
@end



@interface IZValueSelectorView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) IBOutlet id <IZValueSelectorViewDelegate> delegate;
@property (nonatomic,assign) IBOutlet id <IZValueSelectorViewDataSource> dataSource;
@property (nonatomic,assign) BOOL shouldBeTransparent;
@property (nonatomic,assign) BOOL horizontalScrolling;

@property (nonatomic,assign) BOOL debugEnabled;


- (void)reloadData;

@end

