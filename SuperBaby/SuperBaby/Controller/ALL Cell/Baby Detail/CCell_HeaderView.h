//
//  CCell_HeaderView.h
//  SuperBaby
//
//  Created by MAC107 on 11/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCell_HeaderView : UITableViewHeaderFooterView
@property(nonatomic,weak)IBOutlet UIView *viewContent;
@property(nonatomic,weak)IBOutlet UILabel *lblTitle;
@property(nonatomic,weak)IBOutlet UIButton *btnHeader;
@property(nonatomic,weak)IBOutlet UIImageView *imgVArrow;
@end
