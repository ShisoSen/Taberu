//
//  VC_M002.m
//  Taberu0623
//
//  Created by silver on 14-7-6.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "VC_M002.h"

@interface VC_M002 ()

@end

@implementation VC_M002{
    UISegmentedControl *mSegment;
//    UIView *selectedView;
    int selectedIndex;
    NSMutableArray *chooseArray;
    NSMutableArray *menuArray;
    DropDownListView * dropDownView;
}
@synthesize vcms;
@synthesize bu;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化数据
    bu = [[Businesses alloc]init];
    bu.vcm02 = self;
//    [bu initialize:baseinfor.coordinate];
    [bu initialize];
    //初始化segment
    NSArray *segmentData = @[@"列表",@"地图"];
    mSegment = [[UISegmentedControl alloc]initWithItems:segmentData];
    CGRect rect = CGRectMake(110, 6, 120, 36);
    mSegment.frame = rect;
     
    self.navigationItem.titleView = mSegment;
    [mSegment addTarget:self action:@selector(_segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    VC_M002_List __autoreleasing *vcList = [[VC_M002_List alloc]init];
    vcList.mainViewController = self;
    vcList.bu = bu;
    VC_M002_Map __autoreleasing *vcMap = [[VC_M002_Map alloc]init];
    vcMap.mainViewController = self;
    vcms = @[vcList,vcMap];
    //初始化设置显示附近列表界面
    selectedIndex = 0;
    mSegment.selectedSegmentIndex = selectedIndex;
//    selectedView = [(VC_M00 *)vcms[selectedIndex] view];
    [self.view addSubview:[(VC_M00 *)vcms[selectedIndex] view]];
    
    //菜单设置
    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   //section1
                                                   @[@[@"本帮江浙菜",@"小吃快餐",@"西餐",@"火锅",@"面包甜点"],
                                                     @[@"咖啡厅",@"酒吧",@"电影院"],
                                                     @[@"服饰鞋包",@"化妆品",@"数码产品"]],
                                                   //section2
                                                   @[@[@"高到低",@"低到高"],
                                                     @[@"距离",@"评分",@"人气"]]
                                                   ]];
    menuArray = [NSMutableArray arrayWithArray:@[
                                                 //section1
                                                 @[@"美食",@"休闲娱乐",@"购物"],
                                                 //section2
                                                 @[@"价格",@"智能"]
                                                 ]];
    dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 40) dataSource:self delegate:self];
    dropDownView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    dropDownView.mSuperView = self.view;
    //默认显示按照距离排序
    [dropDownView setTitle:chooseArray[1][1][0] inSection:1];
    
    [self.view addSubview:dropDownView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while ([BaseInfor singleton].coordinate.latitude==0||[BaseInfor singleton].coordinate.longitude==0) {
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [bu initialize];
        });

    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTabelCell{
    ((VC_M002_Map *)vcms[1]).bu = bu;
    //刷新table数据
    for (int i = 0; i < [vcms count]; i++) {
        [(VC_M00 *)vcms[i] updateTabelCell];
    }
}
-(void)loadAllMessage{
    [(VC_M00 *)vcms[0] loadAllMessage];
}
- (void)dealloc {

}
#pragma mark - Segment
-(void)_segmentChanged:(UISegmentedControl *)sender{
    if ([sender isEqual:mSegment] && sender.selectedSegmentIndex != selectedIndex) {
        int selecteNew = sender.selectedSegmentIndex;
        NSLog(@"%@ has been selected!",[sender titleForSegmentAtIndex:selecteNew]);
        [[(VC_M00 *)vcms[selectedIndex] view] removeFromSuperview];
        [self.view addSubview:[(VC_M00 *)vcms[selecteNew] view]];
        if (selecteNew == 0) {
            [self.view addSubview:dropDownView];
            [dropDownView addSuperview];
        }else{
            [dropDownView removeFromSuperview];
        }
        selectedIndex = selecteNew;
    }
}
#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"选了section:%d ,index:%d",section,index);
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections:(int) type
{
    switch (type) {
        case M_TABLE_TAG:
            return [chooseArray count];
            break;
        case N_TABLE_TAG:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section mIndex:(NSInteger)mIndex TableType:(int)type
{
    switch (type) {
        case M_TABLE_TAG:{
            NSArray *arry =chooseArray[section][mIndex];
            return [arry count];
        }
            break;
        case N_TABLE_TAG:{
            return [menuArray[section] count];
        }
            break;
        default:
            break;
    }
    return 0;
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index mIndex:(NSInteger)mIndex TableType:(int)type
{    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        NSLog(@"%f||%f",self.view.frame.origin.x,self.view.frame.origin.y);
    switch (type) {
        case M_TABLE_TAG:{
            return chooseArray[section][mIndex][index];
        }
            break;
        case N_TABLE_TAG:{
            return menuArray[section][mIndex];
        }
            break;
        default:
            break;
    }
    return @" ";
}
-(void)didInSelect:(NSInteger)section index:(NSInteger) index mIndex:(NSInteger) mIndex TableType:(int) type{
    if (section == 1) {
        switch (mIndex) {
            case 0:
                [bu sortByFlg:index];
                ((VC_M002_List *)vcms[0]).refreshing = YES;
                [self updateTabelCell];
                break;
            case 1:
                [bu sortByFlg:index+2];
                ((VC_M002_List *)vcms[0]).refreshing = YES;
                [self updateTabelCell];
                break;
            default:
                break;
        }
    }else if (section == 0){
        [bu.buShops removeAllObjects];
        [bu requestByParam:[BaseInfor singleton].coordinate category:chooseArray[section][mIndex][index] page:0];
        ((VC_M002_List *)vcms[0]).refreshing = YES;
        [self updateTabelCell];
    }
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

@end
