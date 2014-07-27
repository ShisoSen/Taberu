//
//  ReviewCell.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;

@interface ReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *user_nickname;
@property (weak, nonatomic) IBOutlet UIImageView *rating_s_img_url;
@property (weak, nonatomic) IBOutlet UILabel *text_excerpt;
@property(nonatomic,retain) EGOImageView *r_egoImgView;
@property bool isLoaded;
-(void)egoBind;
-(void)s_egoImageViewWithImg:(NSString *)imgURLStr;
@end
