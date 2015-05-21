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

        _card = card;
        _iconImageView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _bodyTextLabel = [[UILabel alloc] init];
        _primaryUserLabel = [[UILabel alloc] init];
        _buttonView = [[LEOButtonView alloc] init];

        switch (_card.type) {
            case CardTypeConversation:
                _secondaryUserView = [[LEOSecondaryUserView alloc] initWithCardType:_card.type user:_card.secondaryUser timestamp:_card.timestamp];
                break;
                
            case CardTypeAppointment:
                
                break;
                
            case CardTypeVisit:
                _secondaryUserView = [[LEOSecondaryUserView alloc] initWithCardType:_card.type user:_card.secondaryUser timestamp:_card.timestamp];
                break;
                
            default:
                break;
        }
    }
    

    return self;
}

-(void)setupSubviews{
    
    switch (self.card.type) {
            
        case CardTypeConversation: {
            UIImage *cardIcon = [UIImage imageNamed:@"SMS-32"];
            
            self.iconImageView.image = cardIcon;
            
            self.primaryUserLabel.text = self.card.primaryUser.firstName; //FIXME: Make this capitalized
            
            self.titleLabel.text = self.card.title;
                        self.titleLabel.font = [UIFont leoTitleBoldFont];
            self.titleLabel.textColor = [UIColor leoWarmHeavyGray];
            
            self.bodyTextLabel.text = self.card.body;
            self.bodyTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.bodyTextLabel.numberOfLines = 0;
            self.bodyTextLabel.font = [UIFont leoBodyBasicFont];
            self.bodyTextLabel.textColor = [UIColor leoWarmHeavyGray];
            
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
            self.buttonView.buttonArray = @[testButton1, testButton2];
            
            [self addSubview:self.secondaryUserView];
            [self addSubview:self.primaryUserLabel];
            [self addSubview:self.iconImageView];
            [self addSubview:self.bodyTextLabel];
            [self addSubview:self.titleLabel];
            [self addSubview:self.buttonView];
            break;
            
        }
            
            
        case CardTypeAppointment: {
            UIImage *cardIcon = [UIImage imageNamed:@"SMS-32"];
            
            self.iconImageView.image = cardIcon;
            
            self.primaryUserLabel.text = [self.card.primaryUser.firstName uppercaseString];
            self.primaryUserLabel.font = [UIFont leoBodyBolderFont];
            self.primaryUserLabel.textColor = [UIColor leoWarmHeavyGray];
            
            self.titleLabel = [[UILabel alloc] init];
            self.titleLabel.text = self.card.title;
            self.titleLabel.font = [UIFont leoTitleBoldFont];
            self.titleLabel.textColor = [UIColor leoWarmHeavyGray];
            
            self.bodyTextLabel.text = self.card.body;
            self.bodyTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.bodyTextLabel.numberOfLines = 0;
            self.bodyTextLabel.font = [UIFont leoBodyBasicFont];
            self.bodyTextLabel.textColor = [UIColor leoWarmHeavyGray];
            
            UIButton *testButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [testButton1 setTitle:@"MAKE AN APPOINTMENT" forState:UIControlStateNormal];
            testButton1.backgroundColor = [UIColor clearColor];
            [testButton1 setTitleColor:[UIColor leoWarmHeavyGray] forState:UIControlStateNormal];
            testButton1.titleLabel.font = [UIFont leoBodyBoldFont];
            
            self.buttonView.buttonArray = @[testButton1];
            
            [self addSubview:_primaryUserLabel];
            [self addSubview:_iconImageView];
            [self addSubview:_bodyTextLabel];
            [self addSubview:_titleLabel];
            [self addSubview:_buttonView];
            
            break;
            
        }
            
        case CardTypeVisit: {
            
            UIImage *cardIcon = [UIImage imageNamed:@"SMS-32"];
            
            self.iconImageView.image = cardIcon;
            
            self.primaryUserLabel.text = [self.card.primaryUser.firstName uppercaseString]; //FIXME: Make this capitalized
            self.primaryUserLabel.font = [UIFont leoBodyBolderFont];
            self.primaryUserLabel.textColor = [UIColor leoWarmHeavyGray];
            
            self.titleLabel.text = self.card.title;
            self.titleLabel.font = [UIFont leoTitleBoldFont];
            self.titleLabel.textColor = [UIColor leoWarmHeavyGray];
            
            self.bodyTextLabel.text = self.card.body;
            self.bodyTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.bodyTextLabel.numberOfLines = 0;
            self.bodyTextLabel.font = [UIFont leoBodyBasicFont];
            self.bodyTextLabel.textColor = [UIColor leoWarmHeavyGray];
                        
            [self addSubview:_primaryUserLabel];
            [self addSubview:_iconImageView];
            [self addSubview:_bodyTextLabel];
            [self addSubview:_titleLabel];
            [self addSubview:_buttonView];
            [self addSubview:_secondaryUserView];
            
            break;
            
        }
            
            
            
            
        default:
            break;
            
    }
    
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
    
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
        
        switch (self.card.type) {
            case CardTypeConversation: {
                NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_primaryUserLabel, _titleLabel, _bodyTextLabel, _secondaryUserView, _buttonView, _iconImageView);
                
                NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView(==32)]-(15)-[_titleLabel]|" options:0 metrics:nil views:viewsDictionary];
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
                break;

            case CardTypeAppointment: {
                NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_primaryUserLabel, _titleLabel, _bodyTextLabel, _buttonView, _iconImageView);
                
                NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView(==32)]-(15)-[_titleLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToPrimaryUserLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_primaryUserLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_primaryUserLabel][_titleLabel]-(20)-[_bodyTextLabel]-(10)-[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
                
                [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToPrimaryUserLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
                [self addConstraints:horizontalLayoutConstraintsForButtonView];
                [self addConstraints:verticalLayoutConstraintsForImage];
                [self addConstraints:verticalLayoutConstraintsForText];
                self.constraintsAlreadyUpdated = YES;
                break;
            }
                
            case CardTypeVisit: {
                NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_primaryUserLabel, _titleLabel, _bodyTextLabel, _buttonView, _iconImageView, _secondaryUserView);
                
                NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView(==32)]-(15)-[_titleLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToPrimaryUserLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_primaryUserLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToSecondaryUserView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_secondaryUserView]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                
                NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_primaryUserLabel][_titleLabel]-(20)-[_bodyTextLabel]-(10)-[_secondaryUserView]-(10)-[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
                
                [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToPrimaryUserLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToSecondaryUserView];
                [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
                [self addConstraints:horizontalLayoutConstraintsForButtonView];
                [self addConstraints:verticalLayoutConstraintsForImage];
                [self addConstraints:verticalLayoutConstraintsForText];
                break;
            }
            default:
                break;
        }
        
        self.constraintsAlreadyUpdated = YES;

    }
    
    [super updateConstraints];
}

@end
