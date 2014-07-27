//
//  BsDetailCell.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;

@interface BsDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *product_rating;
@property (nonatomic, strong) UILabel *decoration_rating;
@property (nonatomic, strong) UILabel *service_rating;
@property (nonatomic, strong) UIImageView *r_image;
@property (nonatomic, strong) UIImageView *s_image;
@property (nonatomic, strong) UIButton *sharingBt;
@property(nonatomic,strong) EGOImageView *s_egoImgView;
@property(nonatomic,strong) EGOImageView *r_egoImgView;
-(void)egoBind;
-(void)s_egoImageViewWithImg:(NSString *)imgURLStr;
-(void)r_egoImageViewWithImg:(NSString *)imgURLStr;
@end
