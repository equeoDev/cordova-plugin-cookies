#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface CookiesPlugin : CDVPlugin
{
    //NSString *notificationCallBack;
}

- (void)ready:(CDVInvokedUrlCommand*)command;

- (void)deleteCookiesForHost:(CDVInvokedUrlCommand*)command;
- (void)deleteAllCookies:(CDVInvokedUrlCommand*)command;
- (void)getAllCookies:(CDVInvokedUrlCommand*)command;
- (void)getCookiesForHost:(CDVInvokedUrlCommand*)command;

@end
