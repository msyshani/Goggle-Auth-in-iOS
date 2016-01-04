//
//  MSYGoogleAuth.h
//  
//
//  Created by Mahendra Yadav on 1/4/16.
//
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

static NSString *  kClientId = @"738322076556-3hks7schdvcf8o3f8obflq08fbehf7b7.apps.googleusercontent.com";

@interface MSYGoogleAuth : NSObject<GPPSignInDelegate>


typedef void (^msyGoogleAuth)(BOOL success, NSDictionary * googleDic);

+(instancetype)sharedInstance;
-(void)loginWithGooglewithCompletion:(msyGoogleAuth)completionBlock;



@end
