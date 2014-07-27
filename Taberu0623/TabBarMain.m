//
//  TabBarMain.m
//  Taberu0623
//
//  Created by silver on 14-6-29.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "TabBarMain.h"
#import "BaseInfor.h"
@interface TabBarMain (){
    BaseInfor *baseinfor;
}

@end

@implementation TabBarMain
@synthesize _tabBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initialTarBar];
    [self _initialViewControllers];
    [self showIntroWithCrossDissolve];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Custom tarBar
-(void)_initialTarBar{
    NSArray *navTitle = @[@"附近",@"我的"];
    _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 49, ScreenW, 49)];
    _tabBar.tag = 9;
    _tabBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tabBar];
    for (int i = 0; i < [navTitle count]; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(161*i, 0, 159, 49);
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [bt setBackgroundColor:[UIColor clearColor]];
        bt.titleLabel.font = [UIFont systemFontOfSize:15];
        bt.showsTouchWhenHighlighted = YES;
        bt.tag = i;
        [bt setTitle:[navTitle objectAtIndex:i] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(tarItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBar addSubview:bt];
        if (bt.tag == 0) {
            bt.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:20];
            [bt setSelected:YES];
        }
    }
    UIView *fem = [[UIView alloc]initWithFrame:CGRectMake(159.5, 15, 1, 19)];
    fem.backgroundColor = [UIColor grayColor];
    [_tabBar addSubview:fem];
}
-(void)tarItemClick:(UIButton *)bt{
    for (int i = 0; i < 2; i++) {
        if (bt.tag == i) {
            bt.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:20];
            [bt setSelected:YES];
        }else{
            UIButton *btn = (UIButton *)[_tabBar viewWithTag:i];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setSelected:NO];
        }
    }
    self.selectedIndex = bt.tag;
    self.selectedViewController = [self.viewControllers objectAtIndex:bt.tag];
}
-(void) _initialViewControllers{
    NSArray *viewControllers = @[[[VC_M002 alloc]init],[[VC_M04 alloc]init]];
    NSMutableArray *navViewControllers = [NSMutableArray array];
    for(UIViewController *temp in viewControllers){
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:temp];
        [navViewControllers addObject:nv];
    }
    self.viewControllers = navViewControllers;
}
#pragma mark introPages
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"周 边";
    page1.desc = @"饿了？无聊了？寂寞了？刷周边。列表＋地图，周边吃喝玩乐信息大汇总。总有一家适合你";
    page1.bgImage = [UIImage imageNamed:@"2"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"详情＋收藏";
    page2.desc = @"点击商户，查看商家详情。看评分，听评论，有图有真相。满意商家就收藏，下次还来容易找";
    page2.bgImage = [UIImage imageNamed:@"2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"导航";
    page3.desc = @"好地方，方便去。点击详细地图，公交／步行／自驾行，条条大路通罗马。";
    page3.bgImage = [UIImage imageNamed:@"2"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}
- (void)introDidFinish {
    NSLog(@"Intro callback");
}
@end
