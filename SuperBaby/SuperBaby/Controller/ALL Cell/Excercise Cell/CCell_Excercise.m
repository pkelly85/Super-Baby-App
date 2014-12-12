//
//  CCell_Excercise.m
//  SuperBaby
//
//  Created by MAC107 on 10/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "CCell_Excercise.h"

@implementation CCell_Excercise

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view
{
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.imgV.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.imgV.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.imgV.frame = imageRect;
}
@end
