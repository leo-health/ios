//
//  LEOCardView.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardView.h"
#import "Card.h"
#import "User+Methods.h"
#import <NSDate+DateTools.h>
#import "Role+Methods.h"
#import "UserRole+Methods.h"
#import "UIImage+Extensions.h"
#import "LEOConstants.h"

@interface LEOCardView ()

@property (nonatomic) BOOL constraintsAlreadyUpdated;

@end
@implementation LEOCardView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithCard:(Card *)card
{
    self = [super init];
    if (self) {
        
        _secondaryUserView = [[LEOSecondaryUserView alloc] initWithCardType:card.type user:card.secondaryUser timestamp:card.timestamp];
        
        //FIXME: Switch statement does same thing for all card types
        UIImage *cardIcon;
        switch (card.type) {
            case CardTypeAppointment:
                cardIcon = [UIImage imageNamed:@"SMS-32"];
                break;
                
            case CardTypeConversation:
                cardIcon = [UIImage imageNamed:@"SMS-32"];
                break;
                
            case CardTypeToDo:
                cardIcon = [UIImage imageNamed:@"SMS-32"];
                break;
                
            case CardTypeOther:
                cardIcon = [UIImage imageNamed:@"SMS-32"];
                break;
                
            default:
                cardIcon = [UIImage imageNamed:@"SMS-32"];
                break;
        }
        
        _cardType = card.type;
        
        _iconImageView = [[UIImageView alloc] initWithImage:cardIcon];
        
        _primaryUserLabel = [[UILabel alloc] init];
        _primaryUserLabel.text = card.primaryUser.firstName; //FIXME: Make this capitalized
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = card.title;
        
        _bodyTextLabel = [[UILabel alloc] init];
        _bodyTextLabel.text = card.body;
        _bodyTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _bodyTextLabel.numberOfLines = 0;
        
        UIButton *testButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *testButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [testButton1 setTitle:@"Test1" forState:UIControlStateNormal];
        [testButton2 setTitle:@"Test2" forState:UIControlStateNormal];
        testButton1.backgroundColor = [UIColor clearColor];
        testButton2.backgroundColor = [UIColor clearColor];
        
        _buttonView = [[LEOButtonView alloc] initWithButtonArray:@[testButton1, testButton2]];
        
        [self addSubview:_secondaryUserView];
        [self addSubview:_primaryUserLabel];
        [self addSubview:_iconImageView];
        [self addSubview:_bodyTextLabel];
        [self addSubview:_titleLabel];
        [self addSubview:_buttonView];
        
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



-(void)updateConstraints {
    
    
    if (!self.constraintsAlreadyUpdated) {
        [self removeConstraints:self.constraints];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.primaryUserLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.bodyTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.secondaryUserView.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (self.cardType == CardTypeConversation) {
            NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_primaryUserLabel, _titleLabel, _bodyTextLabel, _secondaryUserView, _buttonView, _iconImageView);
            
            NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_titleLabel]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalLayoutConstraintsForIconToSecondaryUserView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_secondaryUserView]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_secondaryUserView][_titleLabel]-(20)-[_bodyTextLabel][_buttonView]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
            
            [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
            [self addConstraints:horizontalLayoutConstraintsForIconToSecondaryUserView];
            [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
            [self addConstraints:horizontalLayoutConstraintsForButtonView];
            [self addConstraints:verticalLayoutConstraintsForImage];
            [self addConstraints:verticalLayoutConstraintsForText];
            self.constraintsAlreadyUpdated = YES;
        }
    }
    
    [super updateConstraints];
}

@end
