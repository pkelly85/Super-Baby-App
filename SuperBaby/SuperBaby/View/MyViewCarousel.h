//
//  MyViewCarousel.h
//  SuperBaby
//
//  Created by MAC107 on 11/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewCarousel : UIView
@property(nonatomic,weak)IBOutlet UILabel *lblText;
@property(nonatomic,weak)IBOutlet UILabel *lblPrice;

@property(nonatomic,weak)IBOutlet UIButton *btnPlay;
@property(nonatomic,weak)IBOutlet UIButton *btnInfo;
@property(nonatomic,weak)IBOutlet UIImageView *imgVideo;

@end
