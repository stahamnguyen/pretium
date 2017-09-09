# pretium

This is my own project building an almost complete iOS application of photography in Swift.

The main functionalities of the application are:
1. Store and list all photography gears, kits and their detail information so that the user could easily manage and monitor.
2. Calculate important photographic parameters, such as depth of field, shutter speed when stacking ND filters.
3. Provide current weather information and forecasting in next week, as well as indicating golden hours of the current day so that landscape photographer can arrange their time to catch those moment.

In this application, I performed several skills below:
1. Did not use Storyboard. The whole UI is designed by code. Navigation controller was used instead of segue.
2. Manage UICollectionView, UITableView
3. Manage CoreData to store data and combine searching and updating data through UITableView
4. Use alert functionality (UIAlertAction)
5. Use several graphic functionalities such as gradient (CGGradient), customed graphic view (CAShapeLayer)
6. Download and visualize data from 2 REST APIs about weather.
7. Use location service to improve the accuracy of the the weather service
8. Use model MVC to manage the code more easily
