//
//  VC_M04.m
//  Taberu0623
//
//  Created by silver on 14-6-29.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "VC_M04.h"

@interface VC_M04 ()

@end

@implementation VC_M04{
    BOOL refreshing;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    titleLabel.textColor = [UIColor blackColor];  //设置文本颜色
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的收藏";  //设置标题
    self.navigationItem.titleView = titleLabel;
    [self _updateData];
    [self _initialTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    //显示界面即刷新数据
    [self _updateData];
    [_myTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)_updateData{
    _starShops = [FileOperator loadingDataByName:StarFile];
}
#pragma mark - TableView
- (void)  tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        /* First remove this object from the source */
        StarShop __autoreleasing *temp = [_starShops objectAtIndex:indexPath.row];
        [_starShops removeObjectAtIndex:indexPath.row];
        if ([FileOperator containObject:temp fileName:StarFile]>0) {
            NSLog(@"contained");
            [FileOperator deleteObject:temp fileName:StarFile];
        }
        /* Then remove the associated cell from the Table View */
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationLeft];
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section{
    return [_starShops count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FavorListCellIdentifier = @"favorlistcell";
    [self.myTableView registerClass:[UITableViewCell class]
             forCellReuseIdentifier:FavorListCellIdentifier];
    UITableViewCell *listcell = [tableView
                                 dequeueReusableCellWithIdentifier:FavorListCellIdentifier
                                 forIndexPath:indexPath];
    listcell.textLabel.text = ((StarShop *)[_starShops objectAtIndex:indexPath.row]).name;
    return listcell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIBarButtonItem __autoreleasing *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
    VC_D01 __autoreleasing *vcd01 = [[VC_D01 alloc]init];
    BuShops *bshop = [[BuShops alloc]init];
    StarShop __autoreleasing *sshop = (StarShop *)[_starShops objectAtIndex:indexPath.row];
    bshop.business_id = sshop.business_id;
    vcd01.bushops = bshop;
    [vcd01 searchSingleShop];
    [self.navigationController pushViewController:vcd01 animated:YES];
}

-(void)updateTabelCell{
    //    debugMethod();
    [self.myTableView reloadData];
}
- (void) _initialTableView{
    CGRect tableViewFrame = CGRectMake(0.0f,64.0f, ScreenW, ScreenH-113);
    self.myTableView = [[PullingRefreshTableView alloc] initWithFrame:tableViewFrame pullingDelegate:self];
    self.myTableView.headerOnly = YES;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    //    [self.view insertSubview:self.myTableView atIndex:0];
    [self.view addSubview:self.myTableView];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    //    df.dateFormat = @"yyyy-MM-dd HH:mm";
    //    NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
    return [NSDate date];;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.myTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.myTableView tableViewDidEndDragging:scrollView];
}
- (void)loadData{
    if (refreshing) {
        [self _updateData];
        [self updateTabelCell];
        refreshing = NO;
        [self.myTableView tableViewDidFinishedLoading];
        self.myTableView.reachedTheEnd  = NO;
        NSLog(@"refreshing");
    }else{
    }
}
-(void)loadAllMessage{
    [self.myTableView tableViewDidAllLoadedWithMessage:@"已加载全部商户!"];
    self.myTableView.reachedTheEnd  = YES;
}

@end
