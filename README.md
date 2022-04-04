# WorldTour

This project is about interacting with various endpoints and show countries information in very engaging way. As the app launches, it shows countries name and flag image in a 
table view. 

# Instructions 

## How to build
- Open WorldTour.xcworkspace in xcode.
- Click Product Menu and Select Build Option.

IMPORTANT:  PLEASE USE WorldTour.xcworkspace file to open the project in xcode. This is because, this project uses cocaoPods.
- Once project is opened in xcode, hit build to build it.

## How to run in iOS Simulator
- Once the project is built, a project can be run inside a iOS simulator. Select Product Menu -> Run Option.

# Intended User Experience

- When you launch the app, it will fetch countries information from countries API. Please be patient while its fetching this information. Sometimes, It may take a   little while depending on the speed of your internet.
- Once countries information is available, it is shown in the tableview.
- On this table view, it organises countries by region in its individual sections.
- User can select any country by simply tapping on the row.
- Upon tapping of the row, App shows the details view. On details view, it shows country name, country nickname, country flag and lot of other interesting data.
- User can also tap on a weather button to see current weather for the capital city
- User can tap on a gallary button to see images about the country
- User can also mark a perticular country as a favorite country on a details page.
- Favorite countries can be viewed from a Favorite tab.

## Notes
- Each network response is cached in a local database using Core Data.
- If data is available through the cache, It is servered from there.
- On weather view, user also has the ability to refresh the cached data.

## Technology used

iOS / Swift 5, Core Data, UIKit, Alamofire, CocaoPods

- I have built this project using native iOS with latest version of Swift (Swift 5)
- I have used various UIKit components such as table view, collection view, images, labels, navigation controller, tab controller etc
- I have used CORE DATA to save data locally
- I have used CocaoPods to install 3rd Party Dependancy & have used Alamofire package for making network calls.

## Endpoints Used
I have used following publicly available APIs to put together this app.
- Rest Countries - https://restcountries.com/v2/all
- Weatherbit - http://api.weatherbit.io/
- Pixabay - https://pixabay.com



