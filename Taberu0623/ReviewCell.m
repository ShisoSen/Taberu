//
//  ReviewCell.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "ReviewCell.h"
#import "EGOImageView.h"

@implementation ReviewCell
@synthesize isLoaded;
- (void)awakeFromNib
{
    // Initialization code
    isLoaded = true;
    [self egoBind];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)egoBind{
    self.r_egoImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"16_0star.jpg"]];
    self.r_egoImgView.frame = CGRectMake(0.0f, 0.0f, 84.0f, 16.0f);
    self.r_egoImgView.layer.cornerRadius = 40.0f;
    self.r_egoImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.r_egoImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.rating_s_img_url addSubview:_r_egoImgView];
}
-(void)s_egoImageViewWithImg:(NSString *)imgURLStr
{
    NSLog(@"isLoaded :%d",isLoaded);
    if (isLoaded) {
        isLoaded = false;
    }
    self.r_egoImgView.imageURL = [NSURL URLWithString:imgURLStr];
    
}
@end
