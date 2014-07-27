//
//  DropDownListView.m
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//  Modified by 钱思聪 on 14-7-5
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "DropDownListView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        currentExtendSection = -1;
        currentSelectedItem = 0;
        self.dropDownDataSource = datasource;
        self.dropDownDelegate = delegate;
        
        NSInteger sectionNum =0;
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections:)] ) {
            
            sectionNum = [self.dropDownDataSource numberOfSections:M_TABLE_TAG];
        }
        
        if (sectionNum == 0) {
            self = nil;
        }
        
        //初始化默认显示view
        CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
        for (int i = 0; i <sectionNum; i++) {
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height-2)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            NSString *sectionBtnTitle = @"--";
            if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:mIndex:TableType:)]) {
                sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i] mIndex:currentSelectedItem TableType:N_TABLE_TAG];
            }
            [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
            [sectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [self addSubview:sectionBtn];
            
            UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +(sectionWidth - 16), (self.frame.size.height-12)/2, 12, 12)];
            [sectionBtnIv setImage:[UIImage imageNamed:@"down_dark.png"]];
            [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            
            [self addSubview: sectionBtnIv];
            
            if (i<sectionNum && i != 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/4, 1, frame.size.height/2)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:lineView];
            }
            
        }
        
    }
    return self;
}

-(void)sectionBtnTouch:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
    
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];
        currentSelectedItem = 0;
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
    }
    
}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN +section];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (BOOL)isShow
{
    if (currentExtendSection == -1) {
        return NO;
    }
    return YES;
}
-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        CGRect rect = self.mTableView.frame;
        rect.size.height = 0;
        CGRect n_rect = self.nTableView.frame;
        n_rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.mTableView.alpha = 1.0f;
            self.nTableView.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.mTableView.alpha = 0.2;
            self.nTableView.alpha = 0.2;
            
            self.mTableView.frame = rect;
            self.nTableView.frame = n_rect;
        }completion:^(BOOL finished) {
            [self.mTableView removeFromSuperview];
            [self.nTableView removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (!self.mTableView) {
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height , self.frame.size.width, self.mSuperView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
        NSLog(@"%f,%f",self.frame.origin.x,self.frame.origin.y);
        self.mTableBaseView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.mTableBaseView addGestureRecognizer:bgTap];
        
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 240) style:UITableViewStylePlain];
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        
    }
    //加载菜单menu table
    if (!self.nTableView) {
        self.nTableView =[[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, 100, 240) style:UITableViewStylePlain];
        self.nTableView.delegate = self;
        self.nTableView.dataSource = self;
        currentSelectedItem = 0;
    }
    //修改tableview的frame
    //    int sectionWidth = (self.frame.size.width)/[self.dropDownDataSource numberOfSections];
    CGRect rect = self.mTableView.frame;
    rect.origin.x = 101;
    //  rect.origin.x = sectionWidth *section;
    rect.size.width = 219;
    //        rect.size.width = sectionWidth;
    rect.size.height = 0;
    self.mTableView.frame = rect;
    CGRect n_rect = self.nTableView.frame;
    n_rect.size.height = 0;
    self.nTableView.frame = n_rect;
    [self.mSuperView addSubview:self.mTableBaseView];
    [self.mSuperView addSubview:self.mTableView];
    [self.mSuperView addSubview:self.nTableView];
    
    //动画设置位置
    rect.size.height = 240;
    n_rect.size.height = 240;
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableBaseView.alpha = 0.2;
        self.mTableView.alpha = 0.2;
        self.nTableView.alpha = 0.2;
        
        self.mTableBaseView.alpha = 1.0;
        self.mTableView.alpha = 1.0;
        self.nTableView.alpha = 1.0;
        self.mTableView.frame =  rect;
        self.nTableView.frame = n_rect;
    }];
    
    [self.mTableView reloadData];
    [self.nTableView reloadData];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    [self hideExtendedChooseView];
}
#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mTableView == tableView) {
        if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:)]) {
            NSString *chooseCellTitle = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row mIndex:currentSelectedItem TableType:M_TABLE_TAG];
            
            UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
            [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
            
            [self.dropDownDelegate chooseAtSection:currentExtendSection index:indexPath.row];
            [self.dropDownDelegate didInSelect:currentExtendSection index:indexPath.row mIndex:currentSelectedItem TableType:M_TABLE_TAG];
//            [self hideExtendedChooseView];
            [self bgTappedAction:nil];
        }
    }else if(self.nTableView == tableView){
        //todo
        if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:)]) {
            //            NSString *chooseCellTitle = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row mIndex:currentSelectedItem TableType:N_TABLE_TAG];
            //
            //            UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
            //            [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
            
            [self.dropDownDelegate chooseAtSection:currentExtendSection index:indexPath.row];
            //            [self hideExtendedChooseView];
            currentSelectedItem = indexPath.row;
            [self.mTableView reloadData];
        }
    }else{
        //...
    }
    
}

#pragma mark -- UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.mTableView) {
        return 1;
    }else if (tableView == self.nTableView){
        return 1;
    }else{
        //...
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mTableView) {
        return [self.dropDownDataSource numberOfRowsInSection:currentExtendSection mIndex:currentSelectedItem TableType:M_TABLE_TAG];
    }else if (tableView == self.nTableView){
        return [self.dropDownDataSource numberOfRowsInSection:currentExtendSection mIndex:currentSelectedItem TableType:N_TABLE_TAG];
    }else{
        //...
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.mTableView) {
        static NSString * mCellIdentifier = @"mcellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:mCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row mIndex:currentSelectedItem TableType:M_TABLE_TAG];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }else if (tableView == self.nTableView){
        static NSString * nCellIdentifier = @"ncellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:nCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row mIndex:indexPath.row  TableType:N_TABLE_TAG];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }else{
        //...
    }
    return cell;
}
-(void)removeFromSuperview{
    [super removeFromSuperview];
    [self.mTableBaseView removeFromSuperview];
    [self.mTableView removeFromSuperview];
    [self.nTableView removeFromSuperview];
}
-(void)addSuperview{
    if ([self isShow]) {
        [self.mSuperView addSubview:self.mTableBaseView];
        [self.mSuperView addSubview:self.mTableView];
        [self.mSuperView addSubview:self.nTableView];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
