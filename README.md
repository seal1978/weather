About UX
 1. UX base on the png from email.
 2. Using a bottom model to show the detail page, it is easy to go back home page for user.
 3. Using toast to remind the user when input wrong city or no info from API, it will disappear automatically, not so disturb the user.
 4. Show the city on top of the list that is searched last time.
 5. Remove the same data, if the user searches the city repeatedly.
 6. Using Image cache to improve the load speed of image from API.
 7. No button to refresh the weather. But the APP will monitor the APP, if the status changed, such as change into resumed from suspend, will refresh the weather info. (Because the weather info is not changed often like the stock market, and the user will not always open the APP, most time it is suspended and closed.)
 8. 

 About UI
 1. Only follow the png.
 2. Using the png from API, perhaps should use local images to improve the speed and UI.
 3. Consider the SafeArea to different Models of Phones.
 4. Adaptive launch icon, adapting different Android versions.
 5. Animation background。

 About Tech
 1. Code by Dart, because can get both iOS and Android APP.1
 2. Code by Android, such as launch icon etc.


 Todo
 1. Landscape Screen improvement.
 2. Get location and display the weather.
 3. Splash Screen。
 4. Different Animation background between daytime and night.
 

 References
 https://weatherstack.com/documentation