//
//  CCell_Excercise.h
//  SuperBaby
//
//  Created by MAC107 on 10/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCell_Excercise : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView *imgV;
@property(nonatomic,weak)IBOutlet UILabel *lblTitle;


- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;

@end
