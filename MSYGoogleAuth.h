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

static NSString *  kClientId = @"";

@interface MSYGoogleAuth : NSObject<GPPSignInDelegate>


typedef void (^msyGoogleAuth)(BOOL success, NSDictionary * googleDic);

+(instancetype)sharedInstance;
-(void)loginWithGooglewithCompletion:(msyGoogleAuth)completionBlock;



@end
