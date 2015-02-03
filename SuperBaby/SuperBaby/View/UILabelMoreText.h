//
//  UILabelExtended.h
//  SuperBaby
//
//  Created by MAC107 on 30/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UILabelMoreTextDelegate <NSObject>
-(void)expandLabelNow;
@end

@interface UILabelMoreText : UILabel
@property(nonatomic,strong)id <UILabelMoreTextDelegate> delegate;
- (void)setTruncatingText:(NSString *) txt;
- (void)setTruncatingText:(NSString *) txt forNumberOfLines:(int)lines withMoreColor:(UIColor *)color;
@end
