# RideSafe


**CSE 546 —**  **RideSafe**

_Abhineeth Mishra, Justin Colyar, Ayushi Shekhar_


# **Introduction**

Traveling can be a tiring and depleting task. One of the ways we feel that travel is not being addressed at the moment is for traveling sleeping passengers. Oftentimes people have to guess or stress about falling asleep on the subways, buses, or even a Lyft ride if they are fatigued from lack of sleep, extended travel, or drinking. Traditional tracking apps and safety features rely on manual intervention on behalf of an additional party such as family checking the user&#39;s location and do little to notify the user about arriving at their destination, waking the user, and providing automatic safety checks.


# **Background**

It is always painful to miss your stop , reverse your route , go to your stop , and imagine the pain if that would have been the last bus. The existing modern technology and solutions for today are scattered and inconsistent. In our research, we could not find any automatic self-tracking app for sleeping and travel safety. Popular tracking apps that exist limit functionality to simple location tracking and sharing with friends. Moreover, ride-sharing applications provide limited and inconsistent safety mechanisms for traveling. For instance, Lyft allows the user to share their location with family and detect stopping for significant portions of time to verify the user was not in an accident. However, they do not provide any location or prediction services as of yet. As such, users will currently find a lack of automatic safety tracking and an inconsistent safety experience across different types of ride-sharing and travel apps.

Our app hopes to unify and create a tracking travel app that can fulfill all these needs in one simple place. We want to provide individuals with peace of mind for those that do fall asleep on public transport, those that wish to but are too wary, and those that wish for consistent and automatic safety checks during travel. To accomplish this mission, we developed a travel tracking app that allows for not just location sharing with friends and family but also automatic self-monitoring. From a technical perspective, we provided this solution by allowing customers to input their travel destination and then when they travel, allow them to set a wake-up alarm or notification for when they approach their destination by tracking their location and using geo-fencing.

Moreover, for customers that are worried about travel in shared rides, we also provided warning wake-up notifications if we notice a significant deviation from their destination. To accomplish this, we employed prediction techniques and use mapping APIs as a way to determine the safety level of the passenger and wake them up in case of danger. Beyond this, we also incorporated traditional features of a tracking-travel app such as sharing location with friends and family.

There are a few existing solutions available, but these solutions have some limitations. For example , TravAlert[1] works by sending out a GPS ping every X number of seconds to figure out your location relative to your destination. Sleepy travelers can enter whether they&#39;re on a bus or a train and their destination into the app, setting the alert for either minutes or miles away. But , this app works when you are travelling in the bus. Another example that is present is [OmniBuzz for iPhone](https://itunes.apple.com/us/app/omnibuzz-gps-alarm-for-transit/id1076106050?mt=8)[2] —is both highly rated and free. Because it relies on GPS signals that can&#39;t travel far underground, it doesn&#39;t work dependably at all Metro stations.


# **Design and Implementation**

![](RackMultipart20210502-4-om7rho_html_8fb6a77418d841ea.png)

Fig 1 : Architectural Diagram

The Application (Front-End) of the project is developed in Flutter, which offers compatibility with all platforms. The Front-End is connected with REST API&#39;s on Google App Engine and is also connected with Firebase to store and update user data. Google Maps API&#39;s are used to get the user location and navigation directions, and these GPS coordinates are passed to the REST API&#39;s for safety evaluation.

The cloud services used in the project include Google&#39;s Firebase, specifically Google Firestore, Google App Engine, and Google Maps Routing APIs. The first cloud service, Google Cloud Firestore, allows us to store our information about users in Google&#39;s Firebase which is very convenient and compatible with mobile applications and automatically scales to fit the size of our project. Firestore in particular for our application has been used as a means for storing using information regarding their location, distance, ETA, and friends in order to keep an access control list and previous location information that we can utilize to calculate the safety level of the user. Moreover, for Google Maps Routing API, we utilize this cloud service in order to get accurate and up to date information regarding estimated time of arrival, distance, and other useful statistics.

Google App Engine is the core platform where we run all of our app tier services including our Rest APIs. We have 5 core Rest APIs including a location service, geofence service, add friend service, remove friend service, and register user service. As these are the most intensive, time consuming, and computational intensive parts of our application, we decided that they should be computed on our python flask application within GAE rather than the mobile application in order to save user battery powery, allow faster response times, and enable autoscaling. Our Google App Engine instances also serve as a mediator for access to our database in order to ensure that private information is reasonably protected.

Our project provides autoscaling by utilizing a combination of mobile applications, google app engine, and google firestore. In this way, users do not have a single web application funnel but rather a downloadable app. In this way, our front end is scalable in the fact that each individual user operates their own independent instance of our application version on their mobile devices. Moreover, for our application tier that bears the most computational and time intense parts of our application which is where the bottleneck of our application would be, we are able to configure autoscaling on google app engine in order to automatically created instances when the CPU utilization is greater than or equal to 65% or when an instance of the app tier is handling 20 concurrent requests. Furthermore, our database that holds the location information about our users also needs to scale linearly with the number of users that download our application and by using google firestore, firestore instantly provisions and scales our database as needed to fit our storage demands. In this way, our entire application is able to be autoscaled to a vast number of users and address the computational bottleneck that is on our application tier.

Our proposed solution solves the problem statement described in Section 1 as we are able to provide users with a consistent user experience and provide automatic safety checks on our backend which will send alerts to the user if they are traveling suspiciously away from their destination. Moreover, we allow the user to share their location with friends, even those that do not have the application and those not on mobile devices by providing an email-share feature. We also provide the user with a convenient button to contact emergency services should they be in danger. Through this way, the user will be able to have peace of mind regarding their safety and they can travel to various places while sleeping as our app will wake them up upon reaching their destination.

The current solutions for this problem are in ride hailing apps like Uber. That limits the usage to only Uber(or other app) rides, our app can work for any mode of transportation. Also, the additional features like waking up the user when they are near the destination are unique to our app.


# **Testing and evaluation**

our application was tested against all the different constraints. The application was also tested using &quot;Apache Bench &quot; , which is a tool used for stress/load testing. This test was performed to witness auto scaling. To test how fast our application can handle 100 requests with a maximum of 50 requests running concurrently , we fired the below command from our local linux machine , ab -n 100 -c 50 &quot;[https://round-office-312023.wn.r.appspot.com/locationservice?start\_latitude=31.72638&amp;start\_longitude=-112.17878&amp;end\_latitude=42.360081&amp;end\_longitude=-71.058884&amp;userID=0](https://round-office-312023.wn.r.appspot.com/locationservice?start_latitude=31.72638&amp;start_longitude=-112.17878&amp;end_latitude=42.360081&amp;end_longitude=-71.058884&amp;userID=0)&quot;. The above command&#39;s results are shown below:

![](RackMultipart20210502-4-om7rho_html_1b5f5be8dc058913.png)

Figure 2 : Scaled Instances as a result of stress test.

![](RackMultipart20210502-4-om7rho_html_9643cdde21e12b36.png)

Figure 3: CPU Utilization during Stress Testing

![](RackMultipart20210502-4-om7rho_html_2e284103cb2e8cde.png)

Figure 4: Memory Usage during Stress Testing


# **Code**

5.1 CODE FUNCTIONALITY

MOBILE TIER

- The code is an Android Studio Flutter Project, which means that the app is compatible with both Android and iOS. The programming language used for this is Dart.
- The **lib** folder contains the source code.
- The **AllScreens** folder contains the code for all UI pages within the app such as LoginScreen, RegistrationScreen, SearchScreen and MainScreen.
- **AllWidgets** contains the code for UI components such as loading screens.
- The **Assistants** folder contains the code for fetching the data from Google Maps APIs, which will be used in the MainScreen.
- The **DataHandler** folder contains the code for communication with the REST API&#39;s that interact with the endpoints on the App Engine.
- The **Models** folder contains the code for the Main screen which will be used to launch the app, and defines the page routes in the app.

APP TIER (Google App Engine)

- **main.py** : The main.py code is the main document that contains the source code for all 5 of the core services that were deployed as Rest APIs to GAE. Moreover it contains the routing information for these services including the definitions for their HTTP request types. The 5 services contained in this file are the location service, geolocation service, add friend service, delete friend service, and share location service.
- **requirements.txt** : The requirements.txt document contains the necessary python libraries that need to be installed and used in order to make the application functional.
- **app.yml** : The app.yaml file contains key information regarding the configuration settings for the autoscaling and project deployment to google app engine.
- **.gcloudignore** : This file exists simply as a default ignore file for this python flask API backend for the python cache.
- **templates/index.html** : This file is simply a default blank page html page with our app name that exists so that we can route default requests to this page.

5.2 RUNNING THE CODE

Import the project into Android Studio and run the main application in the /lib/main.dart folder running without debug. For the mobile tier, the application should be pulled and an emulator for iOS or Android should be installed(a physical device can also be used). To deploy the app tier, simply transfer the files that exist in the location service folder to google app engine.

Note: Some features of our application such as Email and Emergency services calls do not work on the emulator as these calls rely on the existence of other applications/services that do not come with the emulator. For these to work, the application should be tested on an actual mobile device.


Flutter resources - 
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
