# EasyLink React Native

A demo for EasyLink in React Native.

![Demo Image](http://p3ytow0ri.bkt.clouddn.com/2018-10-15-141345.png)

## Usage

You can find demo script in `App.js`.

1. Include `EasyLink.js` file into your code.
```JavaScript
import EasyLink from './EasyLink';
```

2. Start EasyLink and watch callback data.
```JavaScript
EasyLink.start(ssid, password, data => {
  // print received data
  /* the data is an object, here example:
  {
    client: 0,
    data: {
      IP: "192.168.1.2"
    },
    name: "MK3165_1(003753)"
  }
   */
  console.log("[EasyLink] callback", data);
  
  // do your logic, such as update component render...
  
  // remember stop EasyLink
  EasyLink.stop();
});
```

3. Use IP address (get by step 2) to communicate with Firmware in LAN or do your custom logic.

Finished.

