//
//  HotPotViewController.h
//  HotPot
//
//  Created by Yun on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

typedef enum {
	NETWORK_ACK,
	NETWORK_COINTOSS,
	NETWORK_EVENT
}packetCodes;

@interface HotPotViewController : UIViewController <GKPeerPickerControllerDelegate, GKSessionDelegate>
{
	GKSession *currentsession;
	UIImageView *potato;
	IBOutlet UIButton *pass;
	IBOutlet UIButton *players;
	IBOutlet UIButton *disconnect;
	
	int gameUniqueId;
	NSString  *gamePeerId;
	NSTimer *timer;
	NSInteger gameState;
	int status;
	NSInteger peerStatus;
}

@property (nonatomic,retain) GKSession *currentsession;
@property (nonatomic,retain) UIButton *pass;
@property (nonatomic,retain) UIButton *players;
@property (nonatomic,retain) UIButton *game;
@property (nonatomic,retain) UIButton *disconnect;

@property (nonatomic) NSInteger gameState;
@property (nonatomic) NSInteger peerStatus;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,copy) NSString *gamePeerId;

-(IBAction) btnPlayers : (id) sender;
-(IBAction) btnPass : (id) sender;
-(IBAction) btnDisconnect : (id) sender;
-(void)endgame;
-(void)gameLoop;
-(void)mySendDataToPeers:(GKSession *)session packetID:(int)packetID gameId:(int)gameId;
@end

