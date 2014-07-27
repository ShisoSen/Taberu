//
//  VC_D01.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//
#import "VC_D01.h"
#import "VC_Map01.h"
#import "BsDetailCell.h"
#import "ReviewCell.h"
#import "Reviews.h"
#import "BaseInfor.h"
#import "StarShop.h"
#import "FileOperator.h"

@interface VC_D01 ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end
static NSString *BsDetailCellIdentifier = @"bsdetailcell";
static NSString *InforCellIdentifier = @"inforcell";
static NSString *ReviewCellIdentifier = @"reviewcell";
@implementation VC_D01{
    BsDetailCell *bsdetailcell;
    ReviewCell *reviewcell;
    UITextView *textView;
}
@synthesize bushops;
@synthesize myTableView;
@synthesize bsreviews;
@synthesize singleShop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
    UIBarButtonItem *customRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(favorateAdd)];
    if ([self favorContained]) {
        customRightBarButtonItem.title = @"已收藏";
    }
    self.navigationItem.rightBarButtonItem = customRightBarButtonItem;

    bsreviews = [[BsReviews alloc]init];
    bsreviews.vcm00 = self;
    [bsreviews initialize:[NSString stringWithFormat:@"%@",bushops.business_id]];
    
    [self _initialTableView];
}
//收藏判断
-(BOOL)favorContained{
    StarShop *starShop = [[StarShop alloc]init];
    starShop.business_id =[NSString stringWithFormat:@"%@",bushops.business_id] ;
    if ([FileOperator containObject:starShop fileName:StarFile]>0) {
        NSLog(@"contained");
        return YES;
    }else{
        return NO;
    }
}
-(void)favorateAdd{
//    [FileOperator deleteFile:StarFile];
    StarShop *starShop = [[StarShop alloc]init];
    starShop.name = bushops.name;
    starShop.address = bushops.address;
    starShop.business_id =[NSString stringWithFormat:@"%@",bushops.business_id] ;
    if ([FileOperator containObject:starShop fileName:StarFile]>0) {
        NSLog(@"contained");
        [FileOperator deleteObject:starShop fileName:StarFile];
        self.navigationItem.rightBarButtonItem.title = @"收藏";
    }else{
        NSLog(@"favAdd: %d",[FileOperator addObject:starShop fileName:StarFile]);
        self.navigationItem.rightBarButtonItem.title = @"已收藏";
    }
}
//单商户查询
-(void)searchSingleShop{
    singleShop = [[SingleShop alloc]init];
    singleShop.vcm00 = self;
    [singleShop initialize:bushops.business_id];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section{
    debugMethod();
    switch (section) {
            case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return [bsreviews.bsreviews count];
            break;
        default:
            return 0;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //        debugMethod();
    UITableViewCell *cell = nil;
    Reviews *review;
    UINib *nib;
    switch (indexPath.section) {
        case 0:
            [self.myTableView registerClass:[UITableViewCell class]
                     forCellReuseIdentifier:BsDetailCellIdentifier];
            bsdetailcell = [[BsDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BsDetailCellIdentifier];
            if (singleShop.bushops!=nil) {
                bushops = singleShop.bushops;
            }
            
            [bsdetailcell s_egoImageViewWithImg:bushops.s_photo_url];
            [bsdetailcell r_egoImageViewWithImg:bushops.rating_s_img_url];
            bsdetailcell.name.text = bushops.name;
            bsdetailcell.product_rating.text = [@"口味: " stringByAppendingString:bushops.product_grade];
            bsdetailcell.decoration_rating.text = [@"环境: " stringByAppendingString:bushops.decoration_grade];
            bsdetailcell.service_rating.text = [@"服务: " stringByAppendingString:bushops.service_grade];
            bsdetailcell.price.text = [@"人均: ¥" stringByAppendingString:bushops.avg_price];
            [bsdetailcell.sharingBt addTarget:nil action:@selector(sharingIt:) forControlEvents:UIControlEventTouchUpInside];
            [cell.textLabel setHighlighted:NO];
            cell = bsdetailcell;
            break;
        case 1:
            [self.myTableView registerClass:[UITableViewCell class]
                     forCellReuseIdentifier:InforCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:InforCellIdentifier forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text =[@"地址:" stringByAppendingString:bushops.address];
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    cell.textLabel.font = [UIFont systemFontOfSize:15];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 25.0f);
                    
                    [button setTitle:@"详细地图"
                            forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:12];
                    
                    [button addTarget:self
                               action:@selector(performExpand:)
                     forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.accessoryView = button;
                    
                    [cell.textLabel setHighlighted:NO];
                }
                    break;
                case 1:{
                    cell.textLabel.text =[@"Tel:" stringByAppendingString:bushops.telephone];
                    cell.textLabel.font = [UIFont systemFontOfSize:15];
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 25.0f);
                    
                    [button setTitle:@"电话联系"
                            forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:12];
                    
                    [button addTarget:self
                               action:@selector(performCall:)
                     forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.accessoryView = button;
                    
                    [cell.textLabel setHighlighted:NO];
                }

                    break;
                default:
                    break;
            }
            break;
        case 2:{
            [self.myTableView registerClass:[UITableViewCell class]
                     forCellReuseIdentifier:ReviewCellIdentifier];
            nib = [UINib nibWithNibName:@"ReviewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:ReviewCellIdentifier];
            reviewcell = [tableView dequeueReusableCellWithIdentifier:ReviewCellIdentifier forIndexPath:indexPath];
            review = [bsreviews.bsreviews objectAtIndex:indexPath.row];
            [reviewcell s_egoImageViewWithImg:review.rating_s_img_url];
            //暴力方式，居上对齐...
            reviewcell.user_nickname.text = review.user_nickname;
            NSString *temp= [review.text_excerpt stringByAppendingString:@"\n  \n  \n  \n  \n  "];
            reviewcell.text_excerpt.text = temp;
            [cell.textLabel setHighlighted:NO];
            cell = reviewcell;
        }

            break;
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
- (void) performExpand:(UIButton *)paramSender{
    /* Now do something with the cell if you want to */
    CLLocationCoordinate2D end = (CLLocationCoordinate2D){[bushops.latitude doubleValue] , [bushops.longitude doubleValue]};
    VC_Map01 *vcmap01 = [[VC_Map01 alloc]init];
    vcmap01.start = [BaseInfor singleton].coordinate;
    vcmap01.end =end;
    vcmap01.bushops = bushops;
    [self.navigationController pushViewController:vcmap01 animated:YES];
}
-(void)performCall:(UIButton *)paramSender{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"拨打电话"
                              message:bushops.telephone
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"ok", nil];
    alertView.tag = 11;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11) {
        if (buttonIndex==1) {
            if (bushops.telephone != nil) {
                NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",bushops.telephone];
                NSURL *url = [[NSURL alloc] initWithString:telUrl];
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }
    }
}
-(void)sharingIt:(UIButton *)bt{
    NSLog(@"sharing");
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    baseView.tag = 9;
    baseView.alpha = 0.5;
    baseView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:baseView];
    UIView *SharingView = [[UIView alloc]initWithFrame:CGRectMake(40, 100, 240, 230)];
    SharingView.tag = 10;
    SharingView.alpha = 1.0;
    SharingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    SharingView.layer.masksToBounds = YES;
    SharingView.layer.cornerRadius = 6.0;
    SharingView.layer.borderWidth = 1.0;
    SharingView.layer.borderColor = [[UIColor blueColor] CGColor];
    [self.view addSubview:SharingView];
    textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, 230, 185)];
    textView.text = [bushops.name stringByAppendingString:bushops.address];
    textView.delegate = self;
    textView.textColor = [UIColor blackColor];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.font=[UIFont fontWithName:@"Times New Roman" size:16];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [textView.layer setCornerRadius:10];
    [SharingView addSubview:textView];
    UIButton *okBt = [[UIButton alloc]initWithFrame:CGRectMake(116, 200, 114, 28)];
    [okBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okBt setTitle:@"分享" forState:UIControlStateNormal];
    okBt.showsTouchWhenHighlighted = YES;
    [okBt addTarget:nil action:@selector(okBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [SharingView addSubview:okBt];
    UIButton *canBt = [[UIButton alloc]initWithFrame:CGRectMake(5, 200, 114, 28)];
    [canBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canBt setTitle:@"取消" forState:UIControlStateNormal];
    canBt.showsTouchWhenHighlighted = YES;
    [canBt addTarget:nil action:@selector(canBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [SharingView addSubview:canBt];
    UIView *fenge = [[UIView alloc]initWithFrame:CGRectMake(114.5, 202, 1, 24)];
    fenge.backgroundColor = [UIColor grayColor];
    [SharingView addSubview:fenge];
}
-(void)okBtClick:(UIButton *)bt{
    debugMethod();
    if (textView.text.length > 0) {
        [[self.view viewWithTag:9] removeFromSuperview];
        [[self.view viewWithTag:10] removeFromSuperview];
        
        self.activityViewController = [[UIActivityViewController alloc]
                                       initWithActivityItems:@[textView.text]
                                       applicationActivities:nil];
        [self presentViewController:self.activityViewController
                           animated:YES
                         completion:^{
                             /* Nothing for now */
                         }];
    }
    
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)canBtClick:(UIButton *)bt{
    debugMethod();
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    textView = nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    debugMethod();
    switch (indexPath.section) {
        case 1:
            return 60.0f;
            break;
        case 2:
            return 120.0f;
            break;
        default:
            return 100.0f;
    }
}
- (NSString *) tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (NSString *) tableView:(UITableView *)tableView
 titleForFooterInSection:(NSInteger)section{
    return nil;    
}
- (CGFloat) tableView:(UITableView *)tableView
 heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}

- (CGFloat) tableView:(UITableView *)tableView
 heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        CLLocationCoordinate2D end = (CLLocationCoordinate2D){[bushops.latitude doubleValue] , [bushops.longitude doubleValue]};
//        VC_Map01 *vcmap01 = [[VC_Map01 alloc]init];
//        vcmap01.start = [BaseInfor singleton].coordinate;
//        vcmap01.end =end;
//        vcmap01.bushops = bushops;
//        [self.navigationController pushViewController:vcmap01 animated:YES];
//    }else{
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
}
-(void)updateTabelCell{
    //    debugMethod();
    [self.myTableView reloadData];
}
- (void) _initialTableView{
    CGRect tableViewFrame = CGRectMake(0.0f,0.0f, 320.0f, 519.0f);
    self.myTableView =
    [[UITableView alloc] initWithFrame:tableViewFrame
                                 style:UITableViewStyleGrouped];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    //    [self.view insertSubview:self.myTableView atIndex:0];
    [self.view addSubview:self.myTableView];
}

@end
