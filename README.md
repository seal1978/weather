# WeatherRT

 About UX
 1. UX base on the png from email.
 2. Using bottom model to show the detail page, it is easy to go back home page for user.
 3. Using toast to remind user when input wrong city or no info from API, it will be disappear automatically, not so disturb user.
 4. Show the city on top of list that is searched last time.
 5. Remove the same data, if user search city repeatlly.
 6. Only add the new city weather info, not refresh the old cities, because the API speed is not fast.
 7. No button to refresh the weather. But the APP will monitor the APP, if the status changed, such as change into resumed from suspend, will refresh the weather info. (Because the weather info is not changed often like stock market, and user will not always open the APP, most time it is suspended and closed.)

 About UI
 1. Only follow the png.
 2. Using the png from API, perhaps should use local image to improve the speeed and UI.
 3. Consider the SafeArea to different Model of Phone.
 4. Adapt launch icon, adpating different Android version.

 About Tech
 1. Code by dart, because can get both iOS and Android APP.1


 Todo
 Landscape Screen improvement.
 Get location and display the weather.
 

 Refference
 https://weatherstack.com/documentation




