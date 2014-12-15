//
//  NSMutableAttributedString+Validation.h
//  MiMedic
//
//  Created by MAC107 on 20/08/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (Validation)
-(NSMutableAttributedString *)replaceFonts_withFont:(UIFont *)fontSelected;

-(NSMutableAttributedString *)replaceFonts_Quicksand;

-(float)getHeight_with_width:(float)myWidth;
@end
