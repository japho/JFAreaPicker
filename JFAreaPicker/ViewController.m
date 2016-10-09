//
//  ViewController.m
//  JFAreaPicker
//
//  Created by 汪继峰 on 16/7/8.
//  Copyright © 2016年 汪继峰. All rights reserved.
//

#import "ViewController.h"
#import "JFAreaPicker.h"
#import "JFDatePicker.h"

@interface ViewController () <JFAreaPickerDelegate,JFDatePickerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *provinceNamelabel;
@property (nonatomic, weak) IBOutlet UILabel *provinceCodelabel;
@property (nonatomic, weak) IBOutlet UILabel *cityNamelabel;
@property (nonatomic, weak) IBOutlet UILabel *cityCodelabel;
@property (nonatomic, weak) IBOutlet UILabel *countryNamelabel;
@property (nonatomic, weak) IBOutlet UILabel *countryCodelabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender
{
    JFAreaPicker *areaPicker = [[JFAreaPicker alloc] init];
    areaPicker.pickerContentMode = JFAreaPickerContentModeCenter;
    areaPicker.title = @"请选择所在地区";
    areaPicker.delegate = self;
    [areaPicker show];
}

- (IBAction)datePicker:(id)sender
{
    JFDatePicker *datePicker = [[JFDatePicker alloc] init];
    datePicker.pickerContentMode = JFDatePickerContentModeCenter;
    datePicker.pickerMode = JFDatePickerModeDate;
    datePicker.title = @"请选择生日";
    datePicker.delegate = self;
    [datePicker show];
}

#pragma mark - --- JFAreaPickerDelegate ---

- (void)areaPicker:(JFAreaPicker *)areaPicker getProvinceName:(NSString *)provinceName provinceCode:(NSString *)provinceCode cityName:(NSString *)cityName cityCode:(NSString *)cityCode countryName:(NSString *)countryName countryCode:(NSString *)countryCode
{
    _provinceNamelabel.text = provinceName;
    _provinceCodelabel.text = provinceCode;
    _cityNamelabel.text = cityName;
    _cityCodelabel.text = cityCode;
    _countryNamelabel.text = countryName;
    _countryCodelabel.text = countryCode;
}

- (void)datePicker:(JFDatePicker *)datePicker getSelectedDateString:(NSString *)dateString
{
    _dateLabel.text = dateString;
}

@end
