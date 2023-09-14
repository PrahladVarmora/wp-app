import UIKit
import Flutter
import GoogleMaps
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let locationManager = CLLocationManager()
    var oldLatLong : (CLLocationDegrees,CLLocationDegrees) = (0.0,0.0)
    
    var userToken = ""
    var baseUrl = ""
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //FIXME: Replace with WePro keys
    GMSServices.provideAPIKey("AIzaSyAbcpGoG1u2DESVsJPS8rRY4Ox5GAVxHtw")
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    GeneratedPluginRegistrant.register(with: self)
      let deviceChannel = FlutterMethodChannel(name: "com.wepro.technicians/iOS", binaryMessenger: controller.binaryMessenger)
      prepareMethodHandler(deviceChannel: deviceChannel)

              
    UNUserNotificationCenter.current().delegate = self
    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
           deviceChannel.setMethodCallHandler({
               (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

               if call.method == "startBackgroundLocationFetch" {
                   print("result \(call.arguments)")
                   
                   UserDefaults.standard.set(((call.arguments as! NSArray)[0]) as? AnyObject, forKey: "userTokenForiOS")
                   UserDefaults.standard.set(((call.arguments as! NSArray)[1]) as? AnyObject, forKey: "updateLocationAPIForiOS")
                   
                   
                   let userToken = UserDefaults.standard.value(forKey: "userTokenForiOS") as? String ?? ""
                   let updateLocationUrl = UserDefaults.standard.value(forKey: "updateLocationAPIForiOS") as? String ?? ""
                   
                   
                   print("User Token :- \(userToken)")
                   print("User URL :- \(updateLocationUrl)")
                   
                   
                   self.setupLocationManager()
               //TODO: startBackgroundLocationFetch
//                   self.receiveDeviceModel(result: result)
               }
               else if call.method == "stopBackgroundLocationFetch"{
                   // 9
                   self.stopGetLocation()
//                   result(FlutterMethodNotImplemented)
//                   return
               }
               
           })
       }
}


// import UIKit
// import Flutter
// import GoogleMaps
// import BackgroundTasks
//
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
//         //FIXME: Replace with WePro keys
//         GMSServices.provideAPIKey("AIzaSyAbcpGoG1u2DESVsJPS8rRY4Ox5GAVxHtw")
//         GeneratedPluginRegistrant.register(with: self)
//       //  registerBackgroundTask();
//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }
//      func registerBackgroundTask(){
//          if #available(iOS 12.0, *) {
//              BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.transistorsoft.fetch", using: nil) { task in
//                  self.handleAppRefresh(task: task as! BGAppRefreshTask)
//              }
//          }
//      }
//
// //     func handleAppRefresh(task: BGAppRefreshTask) {
// //         // Schedule a new refresh task.
// //         scheduleAppRefresh()
// //
// //
// //         // Create an operation that performs the main part of the background task.
// //         let operation = RefreshAppContentsOperation().main
// //
// //         // Provide the background task with an expiration handler that cancels the operation.
// //         task.expirationHandler = {
// //             operation.cancel()
// //         }
// //
// //
// //         // Inform the system that the background task is complete
// //         // when the operation completes.
// //         operation.completionBlock = {
// //             task.setTaskCompleted(success: !operation.isCancelled)
// //         }
// //
// //
// //         // Start the operation.
// //         operationQueue.addOperation(operation)
// //     }
// //
// //
// //             func scheduleAppRefresh() {
// //                let request = BGAppRefreshTaskRequest(identifier: "com.transistorsoft.fetch")
// //                // Fetch no earlier than 15 minutes from now.
// //                request.earliestBeginDate = Date(timeIntervalSinceNow: 0)
// //
// //                do {
// //                   try BGTaskScheduler.shared.submit(request)
// //                } catch {
// //                   print("Could not schedule app refresh: \(error)")
// //                }
// //
// //               }
// }
//
// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
            if self.oldLatLong.0 != latitude || self.oldLatLong.1 != longitude{
                self.oldLatLong = (latitude,longitude)
                self.callAPIUpdateLocation(latitude: latitude, longitude: longitude)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        case .denied, .restricted, .notDetermined:
            locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
        @unknown default:
            break
        }
    }
    
    
    func callAPIUpdateLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        guard let userToken = UserDefaults.standard.value(forKey: "userTokenForiOS") as? String else{return}
        guard let updateLocationUrl = UserDefaults.standard.value(forKey: "updateLocationAPIForiOS") as? String else{return}
        
        
        //let apiURLString = "https://api.devasapcrm.com/technicians/users/update_live_location"
        
        guard let apiURL = URL(string: updateLocationUrl) else {
            print("Invalid API URL.")
            return
        }
        
        let headers: [String: String] = [
            "Authorization": userToken,
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        
        // Append latitude data to the request
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"lat\"\r\n\r\n".data(using: .utf8)!)
        httpBody.append("\(latitude)\r\n".data(using: .utf8)!)
        
        // Append longitude data to the request
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"lng\"\r\n\r\n".data(using: .utf8)!)
        httpBody.append("\(longitude)\r\n".data(using: .utf8)!)
        
        // Close the multipart form
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error in API call: \(error.localizedDescription)")
                self.stopGetLocation()
                return
            }
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("API Response: \(jsonString)")
                    if let httpResponse = response as? HTTPURLResponse {
                        print("status code \(httpResponse.statusCode)")
                        if (httpResponse.statusCode == 401) {
                            self.stopGetLocation()
                        }
                    }
                }
            }
        }.resume()
    }
    
    func stopGetLocation(){
        UserDefaults.standard.removeObject(forKey: "userTokenForiOS")
        UserDefaults.standard.removeObject(forKey: "updateLocationAPIForiOS")
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopMonitoringSignificantLocationChanges()
    }
}
