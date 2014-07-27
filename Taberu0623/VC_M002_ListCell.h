//
//  VC_M002_ListCell.h
//  Taberu0623
//
//  Created by silver on 14-7-6.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface VC_M002_ListCell : UITableViewCell
@property (nonatomic, strong)  UIImageView *s_image;
@property (nonatomic, strong)  UILabel *name;
@property (nonatomic, strong)  UIImageView *r_image;
@property (nonatomic, strong)  UILabel *regions;
@property (nonatomic, strong)  UILabel *distance;
@property (nonatomic, strong)  UILabel *categories;
@property(nonatomic,retain) EGOImageView *s_egoImgView;
@property(nonatomic,retain) EGOImageView *r_egoImgView;
-(void)egoBind;
-(void)s_egoImageViewWithImg:(NSString *)imgURLStr;
-(void)r_egoImageViewWithImg:(NSString *)imgURLStr;
@end
