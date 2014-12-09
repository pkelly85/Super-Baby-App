//
//  S_EditBabyInfoVC.m
//  SuperBaby
//
//  Created by MAC107 on 08/12/14.
//  Copyright (c) 2014 tatva. All rights reserved.
//

#import "S_EditBabyInfoVC.h"
#import "AppConstant.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "S_HomeVC.h"

#define BIRTHDATE_SELECT @"birthdateSelected"
#define WEIGHT_SELECT @"weightSelected"
#define HEIGHT_SELECT @"heightSelected"

#define OUNCES @"ounces"
#define POUND @"pound"

@interface UIView (viewRecursion)
- (NSMutableArray*) allSubViews;
@end

@implementation UIView (viewRecursion)
- (NSMutableArray*)allSubViews
{
    NSMutableArray *arr = [[NSMutableArray alloc] init] ;
    [arr addObject:self];
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}
@end

@interface S_EditBabyInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet TPKeyboardAvoidingScrollView *scrlView;
    __weak IBOutlet UIView *viewTop;
    __weak IBOutlet UIImageView *imgV;
    __weak IBOutlet UITextField *txtBabyName;
    
    /*--- piker ---*/
    IBOutlet UIView *viewPiker;
    __weak IBOutlet UIPickerView *piker;
    __weak IBOutlet UIDatePicker *datePiker;
    __weak IBOutlet UIToolbar *toolbar;
    
    /*--- all buttons ---*/
    NSDate *dob;
    __weak IBOutlet UIButton *btn_b_Month;
    __weak IBOutlet UIButton *btn_b_Date;
    __weak IBOutlet UIButton *btn_b_Year;

    __weak IBOutlet UIButton *btn_w_pound;
    __weak IBOutlet UIButton *btn_w_ounces;
    __weak IBOutlet UIButton *btn_height;
    
    NSString *strSelected;
    NSMutableArray *arrWeight;
    NSMutableArray *arrHeight;
}
@end

@implementation S_EditBabyInfoVC

#pragma mark - View Did Load
-(IBAction)back:(id)sender
{
    popView;
}
-(void)close_HUD
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hideHUD;
    });
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if TARGET_IPHONE_SIMULATOR
    //Simulator
    txtBabyName.text = @"Layla";
#else
    // Device
#endif
    
    [self setupPickerView];
    [self setDefaultText];
    
    /*--- set bottom white line ---*/
    [CommonMethods addBottomLine_to_Label:lblTitle withColor:RGBCOLOR(205, 205, 205)];
        
    viewTop.layer.borderColor = RGBCOLOR(205, 205, 205).CGColor;
    viewTop.layer.borderWidth = 1;
    
    
    for (UIView *txtF in scrlView.allSubViews)
    {
        if ([txtF isKindOfClass:[UITextField class]]) {
            UITextField *tft = (UITextField *)txtF;
            tft.layer.borderColor = RGBCOLOR(205, 205, 205).CGColor;
            tft.layer.borderWidth = 1;
            UIView *vEmailPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            tft.leftView = vEmailPadding;
            tft.leftViewMode = UITextFieldViewModeAlways;
            
        }
        else if([txtF isKindOfClass:[UILabel class]])
        {
            UILabel *lbl = (UILabel *)txtF;
            lbl.textColor = RGBCOLOR(100, 100, 100);
        }
        else if ([txtF isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)txtF;
            btn.layer.borderColor = RGBCOLOR(205, 205, 205).CGColor;
            btn.layer.borderWidth = 1;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //[btn.titleLabel setTextColor:RGBCOLOR(100, 100, 100)];
        }
    }
}
-(void)setupPickerView
{
    /*--- set backgroun to white ---*/
    datePiker.backgroundColor = [UIColor whiteColor];
    piker.backgroundColor = [UIColor whiteColor];
    viewPiker.alpha = 0.0;
    
    /*--- set all constraint mask to no ---*/
    viewPiker.translatesAutoresizingMaskIntoConstraints = NO;
    datePiker.translatesAutoresizingMaskIntoConstraints = NO;
    piker.translatesAutoresizingMaskIntoConstraints = NO;
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    /*--- add piker view ---*/
    [self.view addSubview:viewPiker];
    [self.view bringSubviewToFront:viewPiker];
    
    
    /*--- set constraint full view ---*/
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[viewPiker]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,viewPiker)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[viewPiker]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,viewPiker)]];

    /*--- setup weight and height array ---*/
    arrWeight = [[NSMutableArray alloc]init];
    arrHeight = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<100; i++)
        [arrHeight addObject:[NSString stringWithFormat:@"%d",i+1]];
    
    for (int i = 0; i<100; i++)
        [arrWeight addObject:@{POUND:[NSString stringWithFormat:@"%d",i+1],OUNCES:[NSString stringWithFormat:@"%d",i+1]}];
    
    piker.dataSource = nil;
    piker.delegate = nil;
}
-(void)setDefaultText
{
    dob = [NSDate date];
    [btn_b_Date setTitle:[dob convertDateinFormat:@"dd"] forState:UIControlStateNormal];
    [btn_b_Month setTitle:[dob convertDateinFormat:@"MMMM"] forState:UIControlStateNormal];
    [btn_b_Year setTitle:[dob convertDateinFormat:@"yyyy"] forState:UIControlStateNormal];

    [btn_w_pound setTitle:@"1" forState:UIControlStateNormal];
    [btn_w_ounces setTitle:@"1" forState:UIControlStateNormal];

    [btn_height setTitle:@"1" forState:UIControlStateNormal];

}
#pragma mark - IBAction Methods
-(IBAction)doneClicked:(id)sender
{
    [self.view endEditing:YES];
    if ([[txtBabyName.text isNull] isEqualToString:@""]) {
        txtBabyName.text = @"";
        showHUD_with_error(@"Please enter Baby's Name");
        [self close_HUD];
    }
    else
    {
        S_HomeVC *obj = [[S_HomeVC alloc]initWithNibName:@"S_HomeVC" bundle:nil];
        obj.imgBaby = imgV.image;
        [self.navigationController pushViewController:obj animated:YES];
    }
    
}
-(IBAction)btnPhotoClicked:(id)sender
{
    if (ios8)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Image from" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * action)
                                        {
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                        }];
        
        UIAlertAction* takeImage = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                       {
                                           [self btnTakePhotoClicked:nil];
                                       }];
        
        UIAlertAction* chooseImage = [UIAlertAction actionWithTitle:@"Choose Existing" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action)
                                       {
                                           [self btnChoosePhotoClicked:nil];
                                       }];
        
        [alert addAction:cancelAction];
        [alert addAction:takeImage];
        [alert addAction:chooseImage];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        //[self btnTakePhotoClicked:nil];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Image from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing" ,nil];
        [actionSheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self btnTakePhotoClicked:nil];
            break;
        case 1:
            [self btnChoosePhotoClicked:nil];
            break;
        default:
            break;
    }
}
-(void)btnChoosePhotoClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        [CommonMethods displayAlertwithTitle:@"oops!" withMessage:@"Your device doesn't support Photo library." withViewController:self];
    }
}
-(void)btnTakePhotoClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        [CommonMethods displayAlertwithTitle:@"oops!" withMessage:@"Your device doesn't support Camera." withViewController:self];
    }
}
#pragma mark - Birthdate choose
-(IBAction)btnBirthdateClicked:(id)sender
{
    piker.hidden = YES;
    datePiker.hidden = NO;
    
    piker.dataSource = nil;
    piker.delegate = nil;
    
    viewPiker.alpha = 1.0;
    
    datePiker.maximumDate = [NSDate date];
    strSelected = BIRTHDATE_SELECT;
    
    datePiker.date = dob;
}
-(IBAction)btnWeightClicked:(id)sender
{
    datePiker.hidden = YES;
    piker.hidden = NO;

    piker.dataSource = self;
    piker.delegate = self;
    
    viewPiker.alpha = 1.0;
    strSelected = WEIGHT_SELECT;
    
    @try
    {
        [piker selectRow:[[btn_w_pound titleForState:UIControlStateNormal]integerValue]-1 inComponent:0 animated:NO];
        [piker selectRow:[[btn_w_ounces titleForState:UIControlStateNormal]integerValue]-1 inComponent:1 animated:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    

    [piker reloadAllComponents];
    
}
-(IBAction)btnHeightClicked:(id)sender
{
    datePiker.hidden = YES;
    piker.hidden = NO;

    piker.dataSource = self;
    piker.delegate = self;

    viewPiker.alpha = 1.0;
    strSelected = HEIGHT_SELECT;
    
    @try
    {
       [piker selectRow:[[btn_height titleForState:UIControlStateNormal]integerValue]-1 inComponent:0 animated:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    
    [piker reloadAllComponents];

}
-(IBAction)btnDoneClicked:(id)sender
{
    viewPiker.alpha = 0.0;
    if ([strSelected isEqualToString:BIRTHDATE_SELECT])
    {
        NSLog(@"%@",[datePiker.date convertDateinFormat:@"MMMM-dd-yyyy"]);
        dob = datePiker.date;
        
        [btn_b_Date setTitle:[dob convertDateinFormat:@"dd"] forState:UIControlStateNormal];
        [btn_b_Month setTitle:[dob convertDateinFormat:@"MMMM"] forState:UIControlStateNormal];
        [btn_b_Year setTitle:[dob convertDateinFormat:@"yyyy"] forState:UIControlStateNormal];
    }
    else if([strSelected isEqualToString:WEIGHT_SELECT])
    {
        NSString *strPound = arrWeight[[piker selectedRowInComponent:0]][POUND];
        NSString *strOunce = arrWeight[[piker selectedRowInComponent:1]][OUNCES];

        [btn_w_pound setTitle:strPound forState:UIControlStateNormal];
        [btn_w_ounces setTitle:strOunce forState:UIControlStateNormal];
    }
    else
    {
        NSString *strPound = arrHeight[[piker selectedRowInComponent:0] ];

        [btn_height setTitle:strPound forState:UIControlStateNormal];

    }
}
#pragma mark - Picker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([strSelected isEqualToString:WEIGHT_SELECT])
        return 2;
    else
        return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([strSelected isEqualToString:WEIGHT_SELECT])
        return arrWeight.count;
    else
        return arrHeight.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([strSelected isEqualToString:WEIGHT_SELECT])
    {
        if (component == 0) {
            return arrWeight[row][POUND];
        }
        return arrWeight[row][OUNCES];
    }
    else
        return arrHeight[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([strSelected isEqualToString:WEIGHT_SELECT])
    {

        NSString *strPound = arrWeight[[pickerView selectedRowInComponent:0]][POUND];
        NSString *strOunce = arrWeight[[pickerView selectedRowInComponent:1]][OUNCES];
            
        NSLog(@"%@ : %@",strPound,strOunce);
    }
    else
        NSLog(@"%@",arrHeight[row]);
}
#pragma mark - Image Picker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if (img)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            imgV.image = img;
        }];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self btnBirthdateClicked:nil];

    return YES;
}



#pragma mark - Extra
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
