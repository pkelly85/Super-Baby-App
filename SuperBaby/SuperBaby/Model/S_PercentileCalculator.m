//
//  S_PercentileCalculator.m
//  SuperBaby
//
//  Created by MAC107 on 02/02/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import "S_PercentileCalculator.h"
#import "AppConstant.h"

#define POUND_TO_KG 0.453592
#define INCH_TO_CENTIMETER 2.54
//#define M_SQRT1_2 0.707107

@implementation S_PercentileCalculator
/*For the percentile calculations for baby height and width:

In both sheets, Male = 1, Female = 2

For more reference, visit this site:

http://www.cdc.gov/growthcharts/percentile_data_files.htm

Weight
-----------
For Weight, use the attached CSV file wtageinf.csv

Given the Baby's age (in months, rounded to the nearest 0.5 of a month), and Weight in Kilograms:
1.) Find the row which corresponds to the age

2.) Calculate the Z value by:

If the L != 0, then
Z = ((Weight/M)^L)-1/(L*S)
where M = column D, L = column C, S = column E

If the L == 0 , then
Z = ln(Weight/M)/S , where ln = natural logarithm

3.) In the same row, use the Z score and pick the column c where the  c - 1 < Z < c, the percentile of the baby is then whatever header is for column c (3,5,10,25,50,75,90,95,97). If the Z value is greater than the value of the 97th percentile column, then the baby is in the 100th percentile.

Height
--------
For Height, use the attached CSV file lenageinf.csv

Given the Baby's age (in months, rounded to the nearest 0.5 of a month) and the baby's length (in centimeters)

1.) Find the row which corresponds to the age.

2.) Calculate the Z value using the same steps as for Weight

3.) In the same row, again find the correct percentile c using the same logic as Weight. Note you can ignore any column beyond N.*/

- (void)initialize {
    self.arrWeigt = [[NSArray alloc]initWithArray:[self getWeightArray]];
    self.arrHeight = [[NSArray alloc]initWithArray:[self getHeightArray]];
}

+ (S_PercentileCalculator *)sharedManager
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];

        [sharedInstance initialize];
    });
    return sharedInstance;
}
-(void)calculate_percentile:(percentileBlock)complition
{
    /*------------------------------ Set Weight and height ------------------------------*/
    double weightBaby = [[NSString stringWithFormat:@"%@.%@",babyModelGlobal.WeightPounds,babyModelGlobal.WeightOunces] doubleValue] * POUND_TO_KG;
    
    double heightBaby = [[NSString stringWithFormat:@"%@",babyModelGlobal.Height] doubleValue] * INCH_TO_CENTIMETER;

    NSLog(@"Weight :%f    Height : %f",weightBaby,heightBaby);
    
    /*------------------------------ Get Age ------------------------------*/
    double babyAge = [self getBabyAge];
    NSLog(@"Month : %f",babyAge);
    
    /*------------------------------ Get Dictionary per Age ------------------------------*/
    NSDictionary *dictBabyWeight = [self getBaby_weightInfo_with_age:babyAge withSex:@"1"];
    NSLog(@"Baby Weight %@",dictBabyWeight);
   
    NSDictionary *dictBabyHeight = [self getBaby_heightInfo_with_age:babyAge withSex:@"1"];
    NSLog(@"Baby Height %@",dictBabyHeight);

    /*------------------------------ Calculate Value Z ------------------------------*/
    // L=-0.1600954, M=9.476500305, and S=0.11218624
//    double valueZ = [self calculate_Z_Value_withLMS:@"-0.1600954" M:@"9.476500305" S:@"0.11218624" withWeight:9.7];
    double value_Z_Weight = [self calculate_Z_Value_withLMS:dictBabyWeight[@"L"] M:dictBabyWeight[@"M"] S:dictBabyWeight[@"S"] withWeight:weightBaby];
    
    double value_Z_Height = [self calculate_Z_Value_withLMS:dictBabyHeight[@"L"] M:dictBabyHeight[@"M"] S:dictBabyHeight[@"S"] withWeight:heightBaby];

    /*------------------------------ Calculate Percentile ------------------------------*/
    //0.5 * (1 + erf(z_score*M_SQRT1_2))
    double finalPercentileWeight = 0.5 * (1 + erf(value_Z_Weight*M_SQRT1_2));
    NSLog(@"Weight Percentile %f%%",finalPercentileWeight);
    
    double finalPercentileHeight = 0.5 * (1 + erf(value_Z_Height*M_SQRT1_2));
    NSLog(@"Height Percentile %f%%",finalPercentileHeight);

    complition((NSInteger)(finalPercentileWeight*100),(NSInteger)(finalPercentileHeight*100),(NSInteger)babyAge);
}

-(double)getBabyAge
{
    /*--- Calculate Birthday ---*/
    NSArray *arrTemp = [babyModelGlobal.Birthday componentsSeparatedByString:@" "];
    NSDate *dTemp = [arrTemp[0] getDate_withCurrentFormate:@"MM/dd/yyyy"];
    
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate* birthday = [dTemp dateByAddingTimeInterval:timeZoneSeconds];
    
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:birthday toDate:now options:0];
    
    NSInteger year = [components year];
    double month = (float)[components month];
    NSInteger day = [components day];
    
    //NSLog(@"%ld:%ld:%ld", (long)year, (long)month,(long)day);
    
    if (year > 0) {
        month = month + (year * 12);
    }
    
    if (day >= 15) {
        month += 0.5;
    }
    return month;
}
#pragma mark - Calculate Z Value
-(double)calculate_Z_Value_withLMS:(NSString *)strL M:(NSString *)strM S:(NSString *)strS withWeight:(double)weightBaby
{
    double valueZ = 0;
    NSLog(@"%f : %@ : %f",[strL doubleValue],[NSNumber numberWithDouble:[strM doubleValue]],[strS doubleValue]);
    double weight_divide_m = weightBaby / [strM doubleValue];
    if ([strL isEqualToString:@"0"]) {
        //    Z = ln(Weight/M)/S , where ln = natural logarithm
        valueZ = log(weight_divide_m) / [strS doubleValue];

    }
    else
    {
        //    Z = (((Weight/M)^L)-1)/(L*S)
//        NSLog(@"%f",pow(2, 8));
        double restToL = pow(weight_divide_m, [strL doubleValue]) - 1;
        double l_into_s = [strL doubleValue] * [strS doubleValue];
        valueZ = restToL / l_into_s;
    }
    NSLog(@"%f",valueZ);

    return valueZ;
}
#pragma mark - Weight Info
-(NSDictionary *)getBaby_weightInfo_with_age:(double)month withSex:(NSString *)sex
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(Agemos >= %@) AND (Sex == %@)",[NSString stringWithFormat:@"%.1f",month],sex];
    NSArray *arr = [self.arrWeigt filteredArrayUsingPredicate:pred];
    //NSLog(@"%@",arr);
    return (arr.count>0)?arr[0]:nil;
}
-(NSArray *)getWeightArray
{
    NSString *pathName = [[NSBundle mainBundle]pathForResource:@"wtageinf" ofType:@"csv"];
    NSString* fileContents = [NSString stringWithContentsOfFile:pathName encoding:NSUTF8StringEncoding error:nil];
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //Sex,Agemos,L,M,S,P3,P5,P10,P25,P50,P75,P90,P95,P97 = keys
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < allLinedStrings.count ; i++) {
//        NSLog(@"%@",allLinedStrings[i]);
        NSMutableDictionary *dict = [NSMutableDictionary new];
        NSArray *arrTemp = [allLinedStrings[i] componentsSeparatedByString:@","];
        if (![arrTemp containsObject:@"Sex"])
        {
            [dict setValue:arrTemp[0] forKey:@"Sex"];
            [dict setValue:arrTemp[1] forKey:@"Agemos"];
            [dict setValue:arrTemp[2] forKey:@"L"];
            [dict setValue:arrTemp[3] forKey:@"M"];
            [dict setValue:arrTemp[4] forKey:@"S"];
            [arrData addObject:dict];
        }
        
    }
    return [NSArray arrayWithArray:arrData];
}

#pragma mark - Height Info
-(NSDictionary *)getBaby_heightInfo_with_age:(double)month withSex:(NSString *)sex
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(Agemos >= %@) AND (Sex == %@)",[NSString stringWithFormat:@"%.1f",month],sex];
    NSArray *arr = [self.arrHeight filteredArrayUsingPredicate:pred];
    //NSLog(@"%@",arr);
    return (arr.count>0)?arr[0]:nil;
}
-(NSArray *)getHeightArray
{
    NSString *pathName = [[NSBundle mainBundle]pathForResource:@"lenageinf" ofType:@"csv"];
    NSString* fileContents = [NSString stringWithContentsOfFile:pathName encoding:NSUTF8StringEncoding error:nil];
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //Sex,Agemos,L,M,S,P3,P5,P10,P25,P50,P75,P90,P95,P97,Pub3,Pub5,Pub10,Pub25,Pub50,Pub75,Pub90,Pub95,Pub97,Diff3,Diff5,Diff10,Diff25,Diff50,Diff75,Diff90,Diff95,Diff97 = keys
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < allLinedStrings.count ; i++) {
        //        NSLog(@"%@",allLinedStrings[i]);
        NSMutableDictionary *dict = [NSMutableDictionary new];
        NSArray *arrTemp = [allLinedStrings[i] componentsSeparatedByString:@","];
        if (![arrTemp containsObject:@"Sex"]) {
            [dict setValue:arrTemp[0] forKey:@"Sex"];
            [dict setValue:arrTemp[1] forKey:@"Agemos"];
            [dict setValue:arrTemp[2] forKey:@"L"];
            [dict setValue:arrTemp[3] forKey:@"M"];
            [dict setValue:arrTemp[4] forKey:@"S"];
            [arrData addObject:dict];
        }
    }
    return [NSArray arrayWithArray:arrData];
}
@end
