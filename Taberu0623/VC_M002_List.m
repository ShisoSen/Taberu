//
//  VC_M002_List.m
//  Taberu0623
//
//  Created by silver on 14-7-6.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "VC_M002_List.h"

@interface VC_M002_List ()

@end

@implementation VC_M002_List{
    NSInteger page;
}
@synthesize myTableView;
@synthesize bu;
@synthesize mainViewController;
@synthesize refreshing;
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
    self.view.frame = CGRectMake(0, 40, 320, ScreenH-89);
    //数据加载提示label
    UILabel *inforLabel = [[UILabel alloc]init];
    inforLabel.center = self.view.center;
    inforLabel.text = @"数据加载中";
    [self.view addSubview:inforLabel];
    
    [self _initialTableView];
    //default page
    page = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section{
    return [bu.buShops count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ListCellIdentifier = @"listcell";
    [self.myTableView registerClass:[UITableViewCell class]
             forCellReuseIdentifier:ListCellIdentifier];
    VC_M002_ListCell *listcell = [[VC_M002_ListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifier];
    BuShops __autoreleasing*bs;
    if ([bu.buShops count]>0) {
        bs = (BuShops *)[bu.buShops objectAtIndex:indexPath.row];
    }else{
        bs = [[BuShops alloc]init];
    }
    [listcell s_egoImageViewWithImg:bs.s_photo_url];
    [listcell r_egoImageViewWithImg:bs.rating_img_url];
    listcell.name.text = bs.name;
    listcell.regions.text = bs.regions;
    listcell.categories.text = bs.categories;
    listcell.distance.text = [bs.distance stringByAppendingString:@" m"];
    
    return listcell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIBarButtonItem __autoreleasing *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    mainViewController.navigationItem.backBarButtonItem = customLeftBarButtonItem;

    VC_D01 __autoreleasing *vcd01 = [[VC_D01 alloc]init];
    vcd01.bushops = (BuShops *)[bu.buShops objectAtIndex:indexPath.row];
    [mainViewController.navigationController pushViewController:vcd01 animated:YES];

    
}

-(void)updateTabelCell{
    //    debugMethod();
    [self.myTableView reloadData];
    
    if (refreshing) {
        page = 1;
        refreshing = NO;
        [self.myTableView tableViewDidFinishedLoading];
        self.myTableView.reachedTheEnd  = NO;
    }
}
- (void) _initialTableView{
    CGRect tableViewFrame = CGRectMake(0.0f,64.0f, ScreenW, ScreenH-157);
    self.myTableView = [[PullingRefreshTableView alloc] initWithFrame:tableViewFrame pullingDelegate:self];
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
    page++;
    if (refreshing) {
        //refresh
        [bu.buShops removeAllObjects];
        [bu requestByParam:[BaseInfor singleton].coordinate category:@"P" page:0];
        page = 1;
        refreshing = NO;
        [self.myTableView tableViewDidFinishedLoading];
        self.myTableView.reachedTheEnd  = NO;
        NSLog(@"refreshing");
    }else{
        [self.myTableView tableViewDidFinishedLoading];
        self.myTableView.reachedTheEnd  = NO;
        [bu requestByParam:[BaseInfor singleton].coordinate category:@"P" page:page];
    }

}
-(void)loadAllMessage{
    [self.myTableView tableViewDidAllLoadedWithMessage:@"已加载全部商户!"];
    self.myTableView.reachedTheEnd  = YES;
}
@end
