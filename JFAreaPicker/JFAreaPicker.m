//
//  JFAreaPicker.m
//  JFAreaPicker
//
//  Created by 汪继峰 on 16/7/8.
//  Copyright © 2016年 汪继峰. All rights reserved.
//

#import "JFAreaPicker.h"
#import "UIColor+SetColor.h"
#import "XMLDictionary.h"

#define kContentViewHeight 240
#define kContentViewDistance 20
#define kScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

@interface JFAreaPicker () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView         *contentView;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) UIPickerView   *pickerView;
@property (nonatomic, strong) UIButton       *cancleButton;
@property (nonatomic, strong) UIButton       *ensureButton;

@property (nonatomic, strong) NSArray        *provinceArray;/** 全部省份数组*/
@property (nonatomic, strong) NSArray        *cityArray;/** 全部城市数组*/
@property (nonatomic, strong) NSArray        *countryArray;/** 全部乡镇数组*/
@property (nonatomic, strong) NSMutableArray *currentCityArray;/** 当前城市数组*/
@property (nonatomic, strong) NSMutableArray *currentCoutryArray;/** 当前乡镇数组*/
@property (nonatomic, strong) NSString       *provinceName;/** 选择省份名*/
@property (nonatomic, strong) NSString       *cityName;/** 选择城市名*/
@property (nonatomic, strong) NSString       *countryName;/** 选择乡镇名*/
@property (nonatomic, strong) NSString       *provinceCode;/** 省份编码*/
@property (nonatomic, strong) NSString       *cityCode;/** 城市编码*/
@property (nonatomic, strong) NSString       *countryCode;/** 乡镇编码*/

@end

@implementation JFAreaPicker

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        [self loadAreaData];
        [self setupUI];
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    }
    
    return self;
}

#pragma mark - --- Customed Methods ---

//初始化UI
- (void)setupUI
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addSubview:self.cancleButton];
    [self.contentView addSubview:self.ensureButton];
    
    //添加单击手势，用于隐藏视图
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tapGesture];
    
    //为pickerView添加空手势，避免点击取消
    UITapGestureRecognizer *nilTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [self.contentView addGestureRecognizer:nilTapGesture];
}

- (void)show
{
    //将图层显示与window之上
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (self.contentMode == JFAreaPickerContentModeBottom)
    {
        self.contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight + kContentViewHeight / 2);
        self.alpha = 0.0;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight - kContentViewHeight / 2);
            self.alpha = 1.0;
            [self setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.4]];
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        self.contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight + kContentViewHeight / 2);
        self.alpha = 0.0;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
            self.alpha = 1.0;
            [self setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.4]];
        } completion:^(BOOL finished) {
        }];
    }
    
}

- (void)hide
{
    if (self.contentMode == JFAreaPickerContentModeBottom)
    {
        self.contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight - kContentViewHeight / 2);
        self.alpha = 1.0;
        [self setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.4]];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight + kContentViewHeight / 2);
            self.alpha = 0.0;
            [self setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        self.contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
        self.alpha = 1.0;
        [self setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.4]];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight + kContentViewHeight / 2);
            self.alpha = 0.0;
            [self setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
}

- (void)loadAreaData
{
    _currentCityArray = [NSMutableArray array];
    _currentCoutryArray = [NSMutableArray array];
    
    //选择所属地区
    //获取省份，城市，区县数据，并显示
    NSString *cityXMLPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"xml"];
    NSData *cityData = [NSData dataWithContentsOfFile:cityXMLPath];
    NSXMLParser *cityParser = [[NSXMLParser alloc] initWithData:cityData];
    NSDictionary *cityXMLDic = [NSDictionary dictionaryWithXMLParser:cityParser];
    _cityArray = cityXMLDic[@"row"];
    
    NSString *provinceXMLPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"xml"];
    NSData *provinceData = [NSData dataWithContentsOfFile:provinceXMLPath];
    NSXMLParser *provinceParser = [[NSXMLParser alloc] initWithData:provinceData];
    NSDictionary *provinceXMLDic = [NSDictionary dictionaryWithXMLParser:provinceParser];
    _provinceArray = provinceXMLDic[@"row"];
    
    NSString *countryXMLPath = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"xml"];
    NSData *countryData = [NSData dataWithContentsOfFile:countryXMLPath];
    NSXMLParser *countryParser = [[NSXMLParser alloc] initWithData:countryData];
    NSDictionary *countryXMLDic = [NSDictionary dictionaryWithXMLParser:countryParser];
    _countryArray = countryXMLDic[@"row"];
    
    //取出省份的code来遍历属于该省份的市区
    NSString *provinceCode = [[_provinceArray firstObject] objectForKey:@"code"];
    
    for (NSDictionary *tempDic in _cityArray)
    {
        if ([provinceCode isEqualToString:[tempDic objectForKey:@"p_code"]])
        {
            [_currentCityArray addObject:tempDic];
        }
    }
    
    //取出城市code，来遍历属于该城市的乡镇
    NSString *cityCode = [[_currentCityArray firstObject] objectForKey:@"code"];
    
    for (NSDictionary *tempDic in _countryArray)
    {
        if ([cityCode isEqualToString:[tempDic objectForKey:@"p_code"]])
        {
            [_currentCoutryArray addObject:tempDic];
        }
    }
    
    _provinceName = [_provinceArray firstObject][@"name"];
    _provinceCode = [_provinceArray firstObject][@"code"];
    _cityName = [_currentCityArray firstObject][@"name"];
    _cityCode = [_currentCityArray firstObject][@"code"];
    _countryName = [_currentCoutryArray firstObject][@"name"];
    _countryCode = [_currentCoutryArray firstObject][@"code"];
}

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    
    _provinceName = _provinceArray[index0][@"name"];
    _provinceCode = _provinceArray[index0][@"code"];
    
    if (_currentCityArray.count > 0)
    {
        _cityName = _currentCityArray[index1][@"name"];
        _cityCode = _currentCityArray[index1][@"code"];
    }
    else
    {
        _cityName = @"";
        _cityCode = @"";
    }
    
    if (_currentCoutryArray.count > 0)
    {
        _countryName = _currentCoutryArray[index2][@"name"];
        _countryCode = _currentCoutryArray[index2][@"code"];
    }
    else
    {
        _countryName = @"";
        _countryCode = @"";
    }
}

- (void)ensureButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(areaPicker:getProvinceName:provinceCode:cityName:cityCode:countryName:countryCode:)])
    {
        [self.delegate areaPicker:self getProvinceName:_provinceName provinceCode:_provinceCode cityName:_cityName cityCode:_cityCode countryName:_countryName countryCode:_countryCode];
    }
    
    [self hide];
}

#pragma mark - --- UIPickerView Delegate ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _provinceArray.count;
    }
    else if (component == 1)
    {
        return _currentCityArray.count;
    }
    else if (component == 2)
    {
        return _currentCoutryArray.count;
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *areaContent;
    
    if (component == 0)
    {
        areaContent = _provinceArray[row][@"name"];
    }
    else if (component == 1)
    {
        areaContent = _currentCityArray[row][@"name"];
    }
    else if (component == 2)
    {
        areaContent = _currentCoutryArray[row][@"name"];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
    label.text = areaContent;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [_currentCityArray removeAllObjects];
        [_currentCoutryArray removeAllObjects];
        
        //取出省份的code来遍历属于该省份的市区
        NSString *provinceCode = [[_provinceArray objectAtIndex:row] objectForKey:@"code"];
        
        for (NSDictionary *tempDic in _cityArray)
        {
            if ([provinceCode isEqualToString:[tempDic objectForKey:@"p_code"]])
            {
                [_currentCityArray addObject:tempDic];
            }
        }
        
        //取出城市code，来遍历属于该城市的乡镇
        NSString *cityCode = [[_currentCityArray firstObject] objectForKey:@"code"];
        
        for (NSDictionary *tempDic in _countryArray)
        {
            if ([cityCode isEqualToString:[tempDic objectForKey:@"p_code"]])
            {
                [_currentCoutryArray addObject:tempDic];
            }
        }
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (component == 1)
    {
        [_currentCoutryArray removeAllObjects];
        
        //取出城市code，来遍历属于该城市的乡镇
        NSString *cityCode = [[_currentCityArray objectAtIndex:row] objectForKey:@"code"];
        
        for (NSDictionary *tempDic in _countryArray)
        {
            if ([cityCode isEqualToString:[tempDic objectForKey:@"p_code"]])
            {
                [_currentCoutryArray addObject:tempDic];
            }
        }
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    [self reloadData];
}

#pragma mark - --- Setters ---

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

#pragma mark - --- Getters ---

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - kContentViewDistance * 2, kContentViewHeight)];
        _contentView.center = CGPointMake(kScreenWidth / 2, kScreenHeight /2);
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _contentView.frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor hexStringToColor:@"dddddd"];
        [_contentView addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kContentViewHeight - 44, _contentView.frame.size.width, 0.5)];
        bottomLine.backgroundColor = [UIColor hexStringToColor:@"dddddd"];
        [_contentView addSubview:bottomLine];
    }
    
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _contentView.frame.size.width - 15, 44)];
        _titleLabel.textColor = [UIColor hexStringToColor:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _titleLabel;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, _contentView.frame.size.width, kContentViewHeight - 44 * 2)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

- (UIButton *)cancleButton
{
    if (!_cancleButton)
    {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(0, kContentViewHeight - 43.5, _contentView.frame.size.width / 2, 43.5);
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithRed:19/255.0 green:108/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancleButton;
}

- (UIButton *)ensureButton
{
    if (!_ensureButton)
    {
        _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensureButton.frame = CGRectMake(CGRectGetMaxX(_cancleButton.frame), _cancleButton.frame.origin.y, _cancleButton.frame.size.width, _cancleButton.frame.size.height);
        [_ensureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_ensureButton setTitleColor:[UIColor colorWithRed:19/255.0 green:108/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_ensureButton addTarget:self action:@selector(ensureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _ensureButton;
}

@end
