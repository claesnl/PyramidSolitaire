//
//  ViewController.h
//  PyramidSolitaire
//
//  Created by Claes Ladefoged on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    // Row 1
    IBOutlet UIButton *card1;
    // Row 2
    IBOutlet UIButton *card2;
    IBOutlet UIButton *card3;
    // Row 3
    IBOutlet UIButton *card4;
    IBOutlet UIButton *card5;
    IBOutlet UIButton *card6;
    // Row 4
    IBOutlet UIButton *card7;
    IBOutlet UIButton *card8;
    IBOutlet UIButton *card9;
    IBOutlet UIButton *card10;
    // Row 5
    IBOutlet UIButton *card11;
    IBOutlet UIButton *card12;
    IBOutlet UIButton *card13;
    IBOutlet UIButton *card14;
    IBOutlet UIButton *card15;
    // Row 6
    IBOutlet UIButton *card16;
    IBOutlet UIButton *card17;
    IBOutlet UIButton *card18;
    IBOutlet UIButton *card19;
    IBOutlet UIButton *card20;
    IBOutlet UIButton *card21;
    // Row 7
    IBOutlet UIButton *card22;
    IBOutlet UIButton *card23;
    IBOutlet UIButton *card24;
    IBOutlet UIButton *card25;
    IBOutlet UIButton *card26;
    IBOutlet UIButton *card27;
    IBOutlet UIButton *card28;
    // Deck
    IBOutlet UIButton *cardDeckLeft;
    IBOutlet UIButton *cardDeckRight1;
    IBOutlet UIButton *cardDeckRight2;
    // Labels
    IBOutlet UILabel *time;
    IBOutlet UILabel *score;
    IBOutlet UILabel *youHaveWon;
    // Buttons
    IBOutlet UIButton *buttonNewGame;
    
    NSInteger gameState;
    NSInteger secs;
    NSInteger cardsInDeckPointer;
    NSInteger cards[52];
    NSInteger actvTag;
    NSInteger actvIndex;
    NSInteger score_value;
}

@property(nonatomic,retain) IBOutlet UIButton *card1;
@property(nonatomic,retain) IBOutlet UIButton *card2;
@property(nonatomic,retain) IBOutlet UIButton *card3;
@property(nonatomic,retain) IBOutlet UIButton *card4;
@property(nonatomic,retain) IBOutlet UIButton *card5;
@property(nonatomic,retain) IBOutlet UIButton *card6;
@property(nonatomic,retain) IBOutlet UIButton *card7;
@property(nonatomic,retain) IBOutlet UIButton *card8;
@property(nonatomic,retain) IBOutlet UIButton *card9;
@property(nonatomic,retain) IBOutlet UIButton *card10;
@property(nonatomic,retain) IBOutlet UIButton *card11;
@property(nonatomic,retain) IBOutlet UIButton *card12;
@property(nonatomic,retain) IBOutlet UIButton *card13;
@property(nonatomic,retain) IBOutlet UIButton *card14;
@property(nonatomic,retain) IBOutlet UIButton *card15;
@property(nonatomic,retain) IBOutlet UIButton *card16;
@property(nonatomic,retain) IBOutlet UIButton *card17;
@property(nonatomic,retain) IBOutlet UIButton *card18;
@property(nonatomic,retain) IBOutlet UIButton *card19;
@property(nonatomic,retain) IBOutlet UIButton *card20;
@property(nonatomic,retain) IBOutlet UIButton *card21;
@property(nonatomic,retain) IBOutlet UIButton *card22;
@property(nonatomic,retain) IBOutlet UIButton *card23;
@property(nonatomic,retain) IBOutlet UIButton *card24;
@property(nonatomic,retain) IBOutlet UIButton *card25;
@property(nonatomic,retain) IBOutlet UIButton *card26;
@property(nonatomic,retain) IBOutlet UIButton *card27;
@property(nonatomic,retain) IBOutlet UIButton *card28;
@property(nonatomic,retain) IBOutlet UIButton *cardDeckLeft;
@property(nonatomic,retain) IBOutlet UIButton *cardDeckRight1;
@property(nonatomic,retain) IBOutlet UIButton *cardDeckRight2;
@property(nonatomic,retain) IBOutlet UILabel *time;
@property(nonatomic,retain) IBOutlet UILabel *score;
@property(nonatomic,retain) IBOutlet UILabel *youHaveWon;
@property(nonatomic,retain) IBOutlet UIButton *buttonNewGame;
@property(nonatomic) NSInteger gameState;
@property(nonatomic) NSInteger score_value;
-(void)newGame;
-(void)cardSelected:(UIButton*)sender;
-(BOOL)moveIsValid:(int)tag;
-(void)hideCard:(int)tag;
-(void)hideCards:(int)tag1:(int)tag2;
-(void)toggleCard:(int)tag:(BOOL)toggle;
-(void)deckNewCard;
-(void)gameLoop;
-(void)updateScore:(int)val;
@end
