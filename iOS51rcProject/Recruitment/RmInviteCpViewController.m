//
//  RmInviteCpViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-29.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "RmInviteCpViewController.h"
#import "../Class/CommonController.h"
#import "DictionaryPickerView.h"
#import "Toast+UIView.h"

//邀请企业参会
@interface RmInviteCpViewController () <DictionaryPickerDelegate>
@property (retain, nonatomic) IBOutlet UILabel *lbTime;
@property (retain, nonatomic) IBOutlet UILabel *lbAddress;
@property (retain, nonatomic) IBOutlet UILabel *lbPlace;

@property (retain, nonatomic) IBOutlet UIView *viewSearchSelect;

@property (retain, nonatomic) IBOutlet UIButton *btnTimeSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnAddressSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnPlaceSelect;

@property (strong, nonatomic) DictionaryPickerView *DictionaryPicker;
@end

@implementation RmInviteCpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *strWeek = [CommonController getWeek:self.dtBeginTime];
    NSString *strBeginDate = [CommonController stringFromDate:self.dtBeginTime formatType:@"MM-dd"];
    self.lbTime.text = [NSString stringWithFormat:@"%@ (%@)",strBeginDate,strWeek];
    self.lbAddress.text = self.strAddress;
    self.lbPlace.text = self.strPlace;
    
    self.viewSearchSelect.layer.cornerRadius = 5;
    self.viewSearchSelect.layer.borderWidth = 1;
    self.viewSearchSelect.layer.borderColor = [[UIColor colorWithRed:236.f/255.f green:236.f/255.f blue:236.f/255.f alpha:1] CGColor];

    [self.btnTimeSelect addTarget:self action:@selector(showTimeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAddressSelect addTarget:self action:@selector(showAddressTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPlaceSelect addTarget:self action:@selector(showPlaceSelect:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)showTimeSelect:(UIButton *)sender {
    [self cancelDicPicker];
    
    self.DictionaryPicker = [[[DictionaryPickerView alloc] initWithCustom:DictionaryPickerWithRegionL3 pickerMode:DictionaryPickerModeMulti pickerInclude:DictionaryPickerIncludeParent delegate:self defaultValue:self.dtBeginTime defaultName:self.lbTime.text] autorelease];
    [self.DictionaryPicker setTag:1];
    [self.DictionaryPicker showInView:self.view];
}

-(void)showAddressTypeSelect:(UIButton *)sender {
    [self cancelDicPicker];
    self.DictionaryPicker = [[[DictionaryPickerView alloc] initWithCustom:DictionaryPickerWithJobType pickerMode:DictionaryPickerModeMulti pickerInclude:DictionaryPickerIncludeParent delegate:self defaultValue:self.strAddress defaultName:self.lbAddress.text] autorelease];
    [self.DictionaryPicker setTag:2];
    [self.DictionaryPicker showInView:self.view];
}

-(void)showPlaceSelect:(UIButton *)sender {
    [self cancelDicPicker];
    self.DictionaryPicker = [[[DictionaryPickerView alloc] initWithCommon:self pickerMode:DictionaryPickerModeMulti tableName:@"dcIndustry" defalutValue:self.strPlace defaultName:self.lbPlace.text] autorelease];
    
    [self.DictionaryPicker setTag:3];
    NSLog(@"%d",[self.DictionaryPicker retainCount]);
    [self.DictionaryPicker showInView:self.view];
}

- (void)pickerDidChangeStatus:(DictionaryPickerView *)picker
                selectedValue:(NSString *)selectedValue
                 selectedName:(NSString *)selectedName
{
    switch (picker.tag) {
        case 1:
            if (selectedValue.length == 0) {
                [self.view makeToast:@"举办时间不能为空"];
                return;
            }
            //self.regionSelect = selectedValue;
            //self.lbRegionSelect.text = selectedName;
            break;
        case 2:
            self.strAddress = selectedValue;
            if (selectedValue.length == 0) {
                self.lbAddress.text = @"山东省";
            }
            else {
                self.lbAddress.text = selectedName;
            }
            break;
        case 3:
            self.strPlace = selectedValue;
            if (selectedValue.length == 0) {
                self.lbPlace.text = @"所有行业";
            }
            else {
                self.lbPlace.text = selectedName;
            }
            break;
        default:
            break;
    }
    [self cancelDicPicker];
}

-(void)cancelDicPicker
{
    [self.DictionaryPicker cancelPicker];
    self.DictionaryPicker.delegate = nil;
    self.DictionaryPicker = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_lbTime release];
    [_lbAddress release];
    [_lbPlace release];
    [super dealloc];
}
@end
