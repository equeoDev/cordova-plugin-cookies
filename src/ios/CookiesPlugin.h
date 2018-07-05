#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface CookiesPlugin : CDVPlugin
{
    //NSString *notificationCallBack;
}

- (void)ready:(CDVInvokedUrlCommand*)command;

- (void)deleteCookiesFromHost:(CDVInvokedUrlCommand*)command;
- (void)deleteAllCookies:(CDVInvokedUrlCommand*)command;
- (void)getAllCookies:(CDVInvokedUrlCommand*)command;
- (void)getCookiesFromHost:(CDVInvokedUrlCommand*)command;

@end
