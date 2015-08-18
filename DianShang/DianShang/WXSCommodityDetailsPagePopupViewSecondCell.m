//
//  WXSCommodityDetailsPagePopupViewSecondCell.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/16.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSCommodityDetailsPagePopupViewSecondCell.h"

@interface WXSCommodityDetailsPagePopupViewSecondCell ()
{
    UILabel *textLabel;
}
@property(nonatomic, strong) PKYStepper *stepper;

@end

@implementation WXSCommodityDetailsPagePopupViewSecondCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 100.0, 44.0)];
        textLabel.text = @"购买数量";
        [self.contentView addSubview:textLabel];
        //计数器
        self.stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(IPHONE_W - 150.0f - 10.0, 10.0, 150.0f, 44.0)];
        self.stepper.minimum = 1.0f;
        self.stepper.value = 1.0f;
        self.stepper.hidesDecrementWhenMinimum = YES;
        self.stepper.hidesIncrementWhenMaximum = YES;
        self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
        };
        [self.stepper setup];
        [self.contentView addSubview:self.stepper];
    }
    return self;
}

@end
