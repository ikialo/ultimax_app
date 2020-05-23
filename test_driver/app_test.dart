import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main (){
  group("Ultimax Test", (){

    final emailtextFinder = find.byValueKey('email');
    final passwordTextFinder = find.byValueKey('password');
    final login = find.byValueKey("login");
    final main1 = find.byType("MainScreen");
    final opentabs = find.byValueKey("openTabOptions");
    final tabSelection = find.byType("TabSelection");
    final attachment = find.byValueKey("attachment");
    final openImage = find.byValueKey("openImage");
    final openCamera = find.byValueKey("openCamera");

    FlutterDriver driver;

    setUpAll(()async{
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('test gallary', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await driver.tap(emailtextFinder);
      await driver.enterText("isaacsilas05@gmail.com");
      await driver.tap(passwordTextFinder);
      await driver.enterText("password");
      await driver.tap(login);
      await driver.waitFor(main1);
      assert (main1 != null);
      await driver.tap(opentabs);
      await driver.waitFor(tabSelection);
      assert(tabSelection !=null);
      await driver.tap(attachment);
      await driver.tap(openImage);
      await driver.waitUntilNoTransientCallbacks();
    });

    test('test camera', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await driver.tap(emailtextFinder);
      await driver.enterText("isaacsilas05@gmail.com");
      await driver.tap(passwordTextFinder);
      await driver.enterText("password");
      await driver.tap(login);
      await driver.waitFor(main1);
      assert (main1 != null);
      await driver.tap(opentabs);
      await driver.waitFor(tabSelection);
      assert(tabSelection !=null);
      await driver.tap(attachment);
      await driver.tap(openCamera);
      await driver.waitUntilNoTransientCallbacks();
    });
  });


  
}