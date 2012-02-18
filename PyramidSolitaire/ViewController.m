//
//  ViewController.m
//  PyramidSolitaire
//
//  Created by Claes Ladefoged on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define gameRunning 1
#define gameIdle 0
#define scoreToWin 28
#define nrOfCardsInDeck 23
#define cardTypes [NSArray arrayWithObjects: @"hearts", @"clubs", @"diamonds", @"spades", nil]

@implementation ViewController

@synthesize card1,card2,card3,card4,card5,card6,card7,card8,card9,card10,card11,card12,card13,card14,card15,card16,card17,card18,card19,card20,card21,card22,card23,card24,card25,card26,card27,card28,cardDeckLeft,cardDeckRight1,cardDeckRight2,score,time,buttonNewGame,gameState,youHaveWon,score_value;

#define cardsAtTable [NSArray arrayWithObjects: card1,card2,card3,card4,card5,card6,card7,card8,card9,card10,card11,card12,card13,card14,card15,card16,card17,card18,card19,card20,card21,card22,card23,card24,card25,card26,card27,card28,nil]

- (void)newGame
{
    // 1-13: hearts, 14-26: clubs, 27-39: diamonds, 40-52: spades.
    
    // Create list of cards
    for (NSInteger i = 0; i < 52; i++)
        cards[i] = i;
    
    // Shuffle cards:
    for (int i=0; i<52; i++){
        NSUInteger randomIndex = random() % 52;
        NSInteger temp = cards[i];
        cards[i] = cards[randomIndex];
        cards[randomIndex] = temp;
    }
    
    // Place cards out
    for (int i = 0; i<[cardsAtTable count]; i++) {
        NSInteger cardType = cards[i]/13;
        NSInteger cardValue = (cards[i] % 13)+1;
        UIButton *but = [cardsAtTable objectAtIndex:i];
        [but setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@_%d",[cardTypes objectAtIndex:cardType],cardValue]] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(cardSelected:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:i];
        but.hidden = NO;
    }
    
    // Reset deck
    cardsInDeckPointer = -1;
    [cardDeckRight1 setImage:[UIImage imageNamed:@"cards_empty"] forState:UIControlStateNormal];
    [cardDeckRight2 setImage:[UIImage imageNamed:@"cards_empty"] forState:UIControlStateNormal];
    [cardDeckLeft setImage:[UIImage imageNamed:@"cards_back"] forState:UIControlStateNormal];
    cardDeckLeft.hidden = NO;
    
    youHaveWon.hidden = YES;
    
    // Reset counters
    secs = 0;
    score.text = [NSString stringWithFormat:@"%d",self.score_value=0];
    time.text = [NSString stringWithFormat:@"0 sekunder"];
    actvTag = -1;
    actvIndex = -1;
    self.gameState = gameRunning;
}

- (void)hideCard:(int)tag
{
    
    UIButton *card;
    if(tag == 28){
        card = cardDeckRight1;
    } else if(tag == 29){
        card = cardDeckRight2;
    } else {
        card = [cardsAtTable objectAtIndex:tag];
        card.hidden = YES;
        return;
    }
    
    int pointer = 28+cardsInDeckPointer+(28-tag);
    for (int i = pointer; i < 51; i++){
        cards[i] = cards[i+1];
    }
    cards[51] = -1;
    
    cardsInDeckPointer -= 2;
    [self deckNewCard];
}

- (void)hideCards:(int)tag1:(int)tag2
{    
    BOOL ret = NO;
    if(tag1 < 28) {
        UIButton *c1 = [cardsAtTable objectAtIndex:tag1];
        c1.hidden = YES;
        ret = YES;
    }
    if(tag2 < 28) {
        UIButton *c2 = [cardsAtTable objectAtIndex:tag2];
        c2.hidden = YES;
        if(ret) return;
    }
    if(tag1==28){
        for (int i = 28+cardsInDeckPointer; i < 51; i++){
            cards[i] = cards[i+1];
        }
        cards[51] = -1;
    }
    if(tag2==28){
        for (int i = 28+cardsInDeckPointer; i < 51; i++){
            cards[i] = cards[i+1];
        }
        cards[51] = -1;
    }
    if(tag1==29){
        for (int i = 28+cardsInDeckPointer-1; i < 51; i++){
            cards[i] = cards[i+1];
        }
        cards[51] = -1;
    }
    if(tag2==29){
        for (int i = 28+cardsInDeckPointer-1; i < 51; i++){
            cards[i] = cards[i+1];
        }
        cards[51] = -1;
    }
    cardsInDeckPointer -= 2;
    [self deckNewCard];
}

- (void)toggleCard:(int)tag:(BOOL)toggle
{
    NSInteger cardIndex;
    if(tag<28)
        cardIndex = cards[tag];
    else if(tag == 28)
        cardIndex = cards[tag+cardsInDeckPointer];
    else
        cardIndex = cards[tag+cardsInDeckPointer-2];
    NSInteger cardType = cardIndex/13;
    NSInteger cardValue = (cardIndex % 13)+1;
    
    UIButton *card;
    if(tag == 28){
        card = cardDeckRight1;
    } else if(tag == 29){
        card = cardDeckRight2;
    } else {
        card = [cardsAtTable objectAtIndex:tag];
    }
    
    // Cant select deck that is empty
    if((tag==28 || tag==29) && cardsInDeckPointer == -1)
        return;
    else if (tag==29 && cardsInDeckPointer == 0)
        return;
    
    if(toggle){
        [card setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@_%d_",[cardTypes objectAtIndex:cardType],cardValue]] forState:UIControlStateNormal];
    } else {
        [card setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@_%d",[cardTypes objectAtIndex:cardType],cardValue]] forState:UIControlStateNormal];
    }
    
}

- (BOOL)moveIsValid:(int)tag
{
    // Valid if from deck
    if(tag == 28 || tag == 29)
        return YES;
    
    NSInteger cardIndex = cards[tag];
    NSInteger cardValue = (cardIndex % 13)+1;
    
    // Only set if card is uncovered.
    NSInteger row;
    if(tag == 0)
        row = 1;
    else if(tag>0 && tag<=2)
        row = 2;
    else if(tag>2 && tag<=5)
        row = 3;
    else if(tag>5 && tag<=9)
        row = 4;
    else if(tag>9 && tag<=14)
        row = 5;
    else if(tag>14 && tag<=20)
        row = 6;
    else if(tag>20 && tag<=27)
        row = 7;
    if(row < 7){
        UIButton *onTopOfLeft = [cardsAtTable objectAtIndex:(tag+row)];
        UIButton *onTopOfRight = [cardsAtTable objectAtIndex:(tag+row+1)];
        
        // this is the second card
        if(actvTag > -1){
            // Both cards is on top of the card at hand
            if(!onTopOfLeft.isHidden && !onTopOfRight.isHidden)
                return NO;
            // Left card gone
            else if(onTopOfLeft.isHidden && !onTopOfRight.isHidden){
                // Right card is different from active
                if(tag+row+1 != actvTag)
                    return NO;
                // Right card is active one, but sum is not 13
                else if((actvIndex % 13)+1+cardValue!=13)
                    return NO;
                // Right card is active one, and sum is 13
                else {
                    [self hideCards:tag:actvTag];
                    actvTag = -1;
                    [self updateScore:15];
                    return NO;
                }
            }
            // Right card gone
            else if(!onTopOfLeft.isHidden && onTopOfRight.isHidden){
                // Left card is different from active
                if(tag+row != actvTag)
                    return NO;
                // Left card is active one, but sum is not 13
                else if((actvIndex % 13)+1+cardValue!=13)
                    return NO;
                // Left card is active one, and sum is 13
                else {
                    [self hideCards:tag:actvTag];
                    actvTag = -1;
                    [self updateScore:15];
                    return NO;
                }
            }

        // this is the first card, check if free
        } else if(!onTopOfLeft.isHidden || !onTopOfRight.isHidden)
            return NO;
    }
    return YES;
}

- (void)cardSelected:(UIButton*)sender
{
    if(self.gameState == gameRunning){
        UIButton *card = (UIButton *)sender;
        int tag = card.tag;
        
        NSInteger cardIndex;
        if(tag<28)
            cardIndex = cards[tag];
        else if(tag == 28)
            cardIndex = cards[tag+cardsInDeckPointer];
        else
            cardIndex = cards[tag+cardsInDeckPointer-2];
        NSInteger cardValue = (cardIndex % 13)+1;
        
        // Check if card is reachable
        if(![self moveIsValid:tag])
            return;        
        // Check if card is a king
        else if(cardValue==13){
            [self hideCard:tag];
            [self updateScore:5];
            actvTag=-1;
        // Check if this is second card, and if so, if the sum is 13
        } else if(actvTag>-1 && cardValue+(actvIndex % 13)+1==13){
            [self hideCards:tag:actvTag];
            actvTag = -1;
            [self updateScore:10];
        // Check if the selected card and the active card are the same
        } else if(actvTag > -1 && actvIndex==cardIndex){
            [self toggleCard:tag:NO];
            actvTag = -1;
        // Check if this is the first card, if not, swap active
        } else if(actvTag > -1){
            [self toggleCard:actvTag:NO];
            [self toggleCard:tag:YES];
            actvTag = tag;
            actvIndex = cardIndex;
        // This is the first card, set to active
        } else {
            [self toggleCard:tag:YES];
            actvTag = tag;
            actvIndex = cardIndex;
        }
        
    }
}

- (void)deckNewCard
{
    if(self.gameState == gameRunning){
        if(actvTag > -1 && actvTag < 28)
            [self toggleCard:actvTag:NO];
        actvTag = -1;
        if(cardsInDeckPointer < nrOfCardsInDeck){
            if((cards[cardsInDeckPointer+29] % 13)+1==0)
                cardsInDeckPointer--;
            if(cardsInDeckPointer > -1){
                NSInteger cardType = cards[cardsInDeckPointer+28]/13;
                NSInteger cardValue = (cards[cardsInDeckPointer+28] % 13)+1;
                [cardDeckRight2 setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@_%d",[cardTypes objectAtIndex:cardType],cardValue]] forState:UIControlStateNormal];
            } else
                [cardDeckRight2 setImage:[UIImage imageNamed:@"cards_empty"] forState:UIControlStateNormal];
            cardsInDeckPointer++;
            NSInteger cardType = cards[cardsInDeckPointer+28]/13;
            NSInteger cardValue = (cards[cardsInDeckPointer+28] % 13)+1;
            [cardDeckRight1 setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@_%d",[cardTypes objectAtIndex:cardType],cardValue]] forState:UIControlStateNormal];
            if(cardsInDeckPointer==-1)
                [cardDeckRight1 setImage:[UIImage imageNamed:@"cards_empty"] forState:UIControlStateNormal];
        }
        if(cardsInDeckPointer == nrOfCardsInDeck || cards[cardsInDeckPointer+29]==-1)
            cardDeckLeft.hidden = YES;
    }
}

- (void)updateScore:(int)val
{
    score_value += val;
    score.text = [NSString stringWithFormat:@"%d",score_value];
}

- (void)gameLoop
{
    if(self.gameState == gameRunning){
        secs++;
        time.text = [NSString stringWithFormat:@"%d sekunder",secs];
        
        if(secs % 10 == 0)
            [self updateScore:-2];
        
        if(card1.isHidden){
            BOOL theEnd = YES;
            for(int i=28;i<52;i++){
                if(cards[i]>-1)
                    theEnd = NO;
            }
            if(theEnd){
                self.gameState = gameIdle;
                youHaveWon.hidden = NO;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.gameState = gameIdle;
    // Set action to newGame button
    [buttonNewGame addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    [cardDeckLeft addTarget:self action:@selector(deckNewCard) forControlEvents:UIControlEventTouchUpInside];
    [cardDeckRight1 addTarget:self action:@selector(cardSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cardDeckRight1 setTag:28];
    [cardDeckRight2 addTarget:self action:@selector(cardSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cardDeckRight2 setTag:29];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    youHaveWon.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
