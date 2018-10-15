//
//  EasyLinkModule.m
//  DvaStarter
//
//  Created by Chunbo Hu on 2018/6/11.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "EasyLinkModule.h"
#import "EasyLink.h"
@interface EasyLinkModule()<EasyLinkFTCDelegate>
{
  EASYLINK *easylink_config;
}
@end

@implementation EasyLinkModule

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"EasylinkNotification"];
}

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}
RCT_EXPORT_METHOD(stopEasyLink)
{
  RCTLogInfo(@"stopEasyLink");
  dispatch_async(dispatch_get_main_queue(), ^{
    [easylink_config stopTransmitting];
    [easylink_config unInit];
  });
}

RCT_EXPORT_METHOD(startEasyLinkWithData:(NSDictionary *)data)
{
  RCTLogInfo(@"Start Easylink with data: %@ ", data);
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"开始发包了");
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:5];
    easylink_config = [[EASYLINK alloc]initForDebug:true WithDelegate:self];
    [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[NSString class]]) {
        [wlanConfig setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:key];
      }else
      {
        [wlanConfig setObject:obj forKey:key];
      }
    }];
    [easylink_config prepareEasyLink:wlanConfig
                                info:nil
                                mode:EASYLINK_AWS
                             encrypt:nil];
    [easylink_config transmitSettings];
  });
}

#pragma mark - EasyLinkDelegate

- (void)onFound:(NSNumber *)client withName:(NSString *)name mataData:(NSDictionary *)mataDataDict {
  
  NSLog(@" -- %@",mataDataDict);
  NSMutableDictionary *data=[NSMutableDictionary dictionary];
  [mataDataDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    if ([key isEqualToString:@"IP"]) {
      [data setValue:obj forKey:@"IP"];
    }
  }];
  [self sendEventWithName:@"EasylinkNotification" body:@{@"client":client,@"name":name,@"data":data}];
  //  [easylink_config stopTransmitting];
  //  [easylink_config unInit];
}

- (void)onFoundByFTC:(NSNumber *)client withConfiguration:(NSDictionary *)configDict {
  
}
- (void)onDisconnectFromFTC:(NSNumber *)client withError:(bool)err {
  if (err) {
    NSLog(@"EasyLink失败了");
    //    [easylink_config stopTransmitting];
    //    [easylink_config unInit];
  }else
  {
    NSLog(@"EasyLink成功了");
  }
}



@end
