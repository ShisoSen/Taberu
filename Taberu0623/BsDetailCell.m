//
//  BsDetailCell.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "BsDetailCell.h"
#import "EGOImageView.h"

@implementation BsDetailCell
@synthesize name;
@synthesize price;
@synthesize product_rating;
@synthesize decoration_rating;
@synthesize service_rating;
@synthesize r_image;
@synthesize s_image;
@synthesize sharingBt;
@synthesize s_egoImgView;
@synthesize r_egoImgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.frame = CGRectMake(0, 0, 320, 100);
        [self egoBind];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)egoBind{
    self.contentView.frame = CGRectMake(0, 0, 320, 99);
    s_image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 80, 56)];
    s_image.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:s_image];
    s_egoImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"photoDefault.jpg"]];
    s_egoImgView.frame = CGRectMake(0.0f, 0.0f, 80.0f, 56.0f);
    s_egoImgView.layer.cornerRadius = 40.0f;
    s_egoImgView.contentMode = UIViewContentModeScaleAspectFill;
    [s_image addSubview:s_egoImgView];

    r_image = [[UIImageView alloc]initWithFrame:CGRectMake(100, 30, 160, 16)];
    r_image.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:r_image];
    r_egoImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"16_0star.jpg"]];
    r_egoImgView.frame = CGRectMake(0.0f, 0.0f, 84.0f, 16.0f);
    r_egoImgView.layer.cornerRadius = 40.0f;
    r_egoImgView.contentMode = UIViewContentModeScaleAspectFill;
    [r_image addSubview:r_egoImgView];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(8, 5, 200, 20)];
    name.font = [UIFont systemFontOfSize:16.0f];
    price = [[UILabel alloc]initWithFrame:CGRectMake(100, 49, 80, 18)];
    price.font = [UIFont systemFontOfSize:12.0f];
    product_rating = [[UILabel alloc]initWithFrame:CGRectMake(100, 74, 60, 18)];
    product_rating.font = [UIFont systemFontOfSize:12.0f];
    decoration_rating = [[UILabel alloc]initWithFrame:CGRectMake(162, 74, 60, 18)];
    decoration_rating.font = [UIFont systemFontOfSize:12.0f];
    service_rating = [[UILabel alloc]initWithFrame:CGRectMake(224, 74, 60, 18)];
    service_rating.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:name];
    [self.contentView addSubview:price];
    [self.contentView addSubview:product_rating];
    [self.contentView addSubview:decoration_rating];
    [self.contentView addSubview:service_rating];
    
    sharingBt = [[UIButton alloc]initWithFrame:CGRectMake(224, 5, 90, 50)];
    [sharingBt setTitle:@"分享" forState:UIControlStateNormal];
    [sharingBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    sharingBt.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.contentView addSubview:sharingBt];
}
-(void)s_egoImageViewWithImg:(NSString *)imgURLStr
{
    s_egoImgView.imageURL = [NSURL URLWithString:imgURLStr];
    
}
-(void)r_egoImageViewWithImg:(NSString *)imgURLStr
{
    r_egoImgView.imageURL = [NSURL URLWithString:imgURLStr];
    debugMethod();
    
}
@end
