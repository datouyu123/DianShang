//
//  WXSThirdMyAvatarAndNameTableViewCell.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/31.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSThirdMyAvatarAndNameTableViewCell.h"
#import "PersonalMessage.h"

@interface WXSThirdMyAvatarAndNameTableViewCell ()
{
    UIImageView *head;
    UILabel *name;
}

@end

@implementation WXSThirdMyAvatarAndNameTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        head=[[UIImageView alloc]initWithFrame:CGRectMake(20, (80-60)/2, 60, 60)];
        head.contentMode=UIViewContentModeScaleAspectFill;
        head.layer.masksToBounds=YES;
        head.layer.cornerRadius=30;
        
        [self.contentView addSubview:head];
        name = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, IPHONE_W-90, 60)];
        name.textAlignment = NSTextAlignmentLeft;
        name.numberOfLines = 2;
        name.font = [UIFont boldSystemFontOfSize:16.0];
        name.textColor = [UIColor colorWithRed:148.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:1.0];
        name.text = @"Yao";
        [self.contentView addSubview:name];
        
        //右侧辅助箭头
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_W-22, (80-22)/2, 12, 22)];
        arrow.image=[UIImage imageNamed:@"enter_icon"];
        [self.contentView addSubview:arrow];

    }
    return self;
}

- (void)setPerson:(PersonalMessage *)p
{
    name.text = p.nickName;
    if (p.avatarImage != nil && ![p.avatarImage isEqualToString:@""]) {
        
    }
    else{
        if (p.sex == Male) {
            head.image = [UIImage imageNamed:@"default head_male"];
        }
        else{
            head.image = [UIImage imageNamed:@"default head_female"];
        }
    }
    
}


@end
