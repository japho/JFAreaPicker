//
//  JFDatePicker.m
//  JFAreaPicker
//
//  Created by 汪继峰 on 16/7/11.
//  Copyright © 2016年 汪继峰. All rights reserved.
//

#import "JFDatePicker.h"
#import "UIColor+SetColor.h"

#define kContentViewHeight 240
#define kContentViewDistance 20
#define kScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

@interface JFDatePicker ()

@property (nonatomic, strong) UIView       *contentView;
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton     *cancleButton;
@property (nonatomic, strong) UIButton     *ensureButton;

@end

@implementation JFDatePicker

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        [self setupUI];
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    }
    
    return self;
}

#pragma mark - --- Customed Methods ---

- (void)setupUI
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.datePicker];
    [self.contentView addSubview:self.cancleButton];
    [self.contentView addSubview:self.ensureButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *nilTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [self.contentView addGestureRecognizer:nilTapGesture];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (self.pickerContentMode == JFDatePickerContentModeBottom)
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
    if (self.pickerContentMode == JFDatePickerContentModeBottom)
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

- (void)ensureButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:getSelectedDateString:)])
    {
        NSDate *date = _datePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        [self.delegate datePicker:self getSelectedDateString:dateString];
    }
    
    [self hide];
}

#pragma mark - --- Setters ---

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setPickerMode:(JFDatePickerMode)pickerMode
{
    _pickerMode = pickerMode;
    _datePicker.datePickerMode = (UIDatePickerMode)pickerMode;
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

- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, _contentView.frame.size.width, kContentViewHeight - 44 * 2)];
        [_datePicker setBackgroundColor:[UIColor whiteColor]];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
    
    return _datePicker;
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
