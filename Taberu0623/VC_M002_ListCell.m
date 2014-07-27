//
//  VC_M002_ListCell.m
//  Taberu0623
//
//  Created by silver on 14-7-6.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "VC_M002_ListCell.h"

@implementation VC_M002_ListCell
@synthesize s_image;
@synthesize r_image;
@synthesize s_egoImgView;
@synthesize r_egoImgView;
@synthesize name;
@synthesize regions;
@synthesize distance;
@synthesize categories;
- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.frame = CGRectMake(0, 0, 320, 70);
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
    s_image = [[UIImageView alloc]initWithFrame:CGRectMake(2, 7, 80, 56)];
    s_image.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:s_image];
    s_egoImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"photoDefault.jpg"]];
    s_egoImgView.frame = CGRectMake(0.0f, 0.0f, 80.0f, 56.0f);
    s_egoImgView.layer.cornerRadius = 40.0f;
    s_egoImgView.contentMode = UIViewContentModeScaleAspectFill;
    [s_image addSubview:s_egoImgView];
    s_image.contentMode = UIViewContentModeScaleAspectFill;
    
    r_image = [[UIImageView alloc]initWithFrame:CGRectMake(100, 26, 160, 16)];
    r_egoImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:r_image];
    r_egoImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"16_0star.jpg"]];
    r_egoImgView.frame = CGRectMake(0.0f, 0.0f, 84.0f, 16.0f);
    r_egoImgView.layer.cornerRadius = 40.0f;
    r_egoImgView.contentMode = UIViewContentModeScaleAspectFill;
    [r_image addSubview:r_egoImgView];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(100, 2, 200, 21)];
    name.font = [UIFont systemFontOfSize:16.0f];
    distance = [[UILabel alloc]initWithFrame:CGRectMake(268, 26, 50, 16)];
    distance.font = [UIFont systemFontOfSize:10.0f];
    regions = [[UILabel alloc]initWithFrame:CGRectMake(100, 48, 100, 16)];
    regions.font = [UIFont systemFontOfSize:12.0f];
    categories = [[UILabel alloc]initWithFrame:CGRectMake(220, 48, 80, 16)];
    categories.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:name];
    [self.contentView addSubview:distance];
    [self.contentView addSubview:regions];
    [self.contentView addSubview:categories];
}
-(void)s_egoImageViewWithImg:(NSString *)imgURLStr
{
    debugMethod();
    s_egoImgView.imageURL = [NSURL URLWithString:imgURLStr];
    
}
-(void)r_egoImageViewWithImg:(NSString *)imgURLStr
{
    debugMethod();
    r_egoImgView.imageURL = [NSURL URLWithString:imgURLStr];
    
}
@end
