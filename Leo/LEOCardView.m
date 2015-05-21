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
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
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
        
        //FIXME: Icon is the same for all card types

        switch (card.type) {
                
            case CardTypeConversation: {
                UIImage *cardIcon = [UIImage imageNamed:@"SMS-32"];
                
                _secondaryUserView = [[LEOSecondaryUserView alloc] initWithCardType:card.type user:card.secondaryUser timestamp:card.timestamp];
                
                _cardType = card.type;
                
                _iconImageView = [[UIImageView alloc] initWithImage:cardIcon];
                
                _primaryUserLabel = [[UILabel alloc] init];
                _primaryUserLabel.text = card.primaryUser.firstName; //FIXME: Make this capitalized
                
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.text = card.title;
                _titleLabel.font = [UIFont leoTitleBoldFont];
                _titleLabel.textColor = [UIColor leoWarmHeavyGray];
                
                _bodyTextLabel = [[UILabel alloc] init];
                _bodyTextLabel.text = card.body;
                _bodyTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
                _bodyTextLabel.numberOfLines = 0;
                _bodyTextLabel.font = [UIFont leoBodyBasicFont];
                _bodyTextLabel.textColor = [UIColor leoWarmHeavyGray];
                UIButton *testButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
                UIButton *testButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [testButton1 setTitle:@"REPLY" forState:UIControlStateNormal];
                [testButton2 setTitle:@"CALL US" forState:UIControlStateNormal];
                testButton1.backgroundColor = [UIColor clearColor];
                testButton2.backgroundColor = [UIColor clearColor];
                [testButton1 setTitleColor:[UIColor leoWarmHeavyGray] forState:UIControlStateNormal];
                [testButton2 setTitleColor:[UIColor leoWarmHeavyGray] forState:UIControlStateNormal];
                testButton1.titleLabel.font = [UIFont leoBodyBoldFont];
                testButton2.titleLabel.font = [UIFont leoBodyBoldFont];
                _buttonView = [[LEOButtonView alloc] initWithButtonArray:@[testButton1, testButton2]];

                [self addSubview:_secondaryUserView];
                [self addSubview:_primaryUserLabel];
                [self addSubview:_iconImageView];
                [self addSubview:_bodyTextLabel];
                [self addSubview:_titleLabel];
                [self addSubview:_buttonView];
                
                self.layer.cornerRadius = 5;
                self.backgroundColor = [UIColor whiteColor];
                break;

            }
                
                
            case CardTypeAppointment: {
                UIImage *cardIcon = [UIImage imageNamed:@"SMS-32"];
                
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
                testButton1.backgroundColor = [UIColor blueColor];
                testButton2.backgroundColor = [UIColor clearColor];
                
                _buttonView = [[LEOButtonView alloc] initWithButtonArray:@[testButton1, testButton2]];
                
                [self addSubview:_primaryUserLabel];
                [self addSubview:_iconImageView];
                [self addSubview:_bodyTextLabel];
                [self addSubview:_titleLabel];
                [self addSubview:_buttonView];
                
                self.layer.cornerRadius = 5;
                self.backgroundColor = [UIColor whiteColor];
                break;

            }

                
                
            default:
                break;
                
        }
        
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
            NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_secondaryUserView][_titleLabel]-(20)-[_bodyTextLabel]-(10)-[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
            
            [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
            [self addConstraints:horizontalLayoutConstraintsForIconToSecondaryUserView];
            [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
            [self addConstraints:horizontalLayoutConstraintsForButtonView];
            [self addConstraints:verticalLayoutConstraintsForImage];
            [self addConstraints:verticalLayoutConstraintsForText];
            self.constraintsAlreadyUpdated = YES;
        }
        else if (self.cardType == CardTypeAppointment) {
            
            NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_primaryUserLabel, _titleLabel, _bodyTextLabel, _buttonView, _iconImageView);
            
            NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_titleLabel]" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalLayoutConstraintsForIconToPrimaryUserView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_primaryUserLabel]" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
            NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_primaryUserLabel][_titleLabel]-(20)-[_bodyTextLabel][_buttonView]|" options:0 metrics:nil views:viewsDictionary];
            NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
            
            [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
            [self addConstraints:horizontalLayoutConstraintsForIconToPrimaryUserView];
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
