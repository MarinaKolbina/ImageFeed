# Image Feed

# Links

- [Design in Figma](https://tinyurl.com/image-feed-figma)
- [Unsplash API](https://unsplash.com/documentation)

# Purpose and goals of the application

The multi-page app is designed to view images via the Unsplash API.

Application goals:

- View an endless feed of images from Unsplash Editorial.
- View brief information from the user profile.

# Brief description of the application

- The application requires authorization via OAuth Unsplash.
- The main screen consists of a ribbon with images. The user can view it, add and remove images from favorites.
- Users can view each image individually and share a link to them outside the app.
- The user has a profile with featured images and brief information about the user.
- The application has two versions: advanced and basic. The extended version adds the favorites mechanic and the ability to like photos when viewing the image in full screen.

# Non-functional requirements

## Technical requirements

1. Authorization works through OAuth Unsplash and POST request to receive an Auth Token.
2. The ribbon is implemented using UITableView.
3. The application uses UImageView, UIButton, UILabel, TabBarController, NavigationController, NavigationBar, UITableView, UITableViewCell.
4. The application must support iPhone devices with iOS 13 or higher, only portrait mode is provided.
5. All fonts in the application are system fonts, no need to download them; in Interface Builder this is the “System” font in the drop-down list, and when layout from code - [`systemFont(ofSize:weight:)`](https://developer.apple.com/documentation/uikit/uifont/1619027-systemfont) . In current versions of iOS (13-16), the system font is the `SF Pro` font, but it may change in future versions.

# Functional requirements

# Authorization via OAuth

To log into the application, the user must authorize via OAuth.

**The login screen contains:**

1. Application logo
2. “Login” button

**Algorithms and available actions:**

1. When entering the application, the user sees a splash-screen;
2. After downloading the application, a screen with the option to log in opens;
     1. When you click on the “Login” button, the browser opens on the Unsplash login page;
         1. When you click on the “Login” button, the browser closes. A loading screen appears in the application;
         2. If authorization via OAuth Unsplash is not configured, nothing happens when you click the login button;
         3. If authorization via OAuth Unsplash is not configured correctly, the user will not be able to log into the application;
         4. If the login attempt is unsuccessful, a modal window with an error pops up;
             1. When clicking “OK” the user goes back to the authorization screen;
         5. If authorization is successful, the browser closes. The app opens to a screen with a ribbon.

## View feed

In the feed, the user can view images in the feed, navigate to an individual image, and add them to favorites.

**The Ribbon Screen Contains:**

1. Card with an image;
     1. Like button;
     2. Date the photo was uploaded;
2. Tab bar for navigation between feed and profile.

**Algorithms and available actions:**

1. The ribbon screen opens by default after logging into the application;
2. The feed contains images from Unsplash Editorial;
3. When scrolling down and up, the user can view the feed;
     1. If the image has not yet loaded, the system loader is displayed to the user;
     2. If the image cannot be loaded, the user sees a placeholder instead of an image;
4. By clicking on the Like button (gray heart), the user can like the image. After clicking, the loader is displayed:
     1. If the request is successful, then the loader disappears, the icon changes state to the Red Like Button (red heart).
     2. If the request is not successful, a modal window pops up with the error “try again”
5. The user can remove the like by clicking the Like button (red heart) again. After clicking, the loader is displayed:
     1. If the request is successful, the loader disappears and the icon changes state to a gray heart.
     2. If the request is not successful, a modal window pops up with the error “try again”;
6. When you click on a card with an image, it will enlarge to the borders of the phone and the user will go to the image viewing screen (section “Viewing an image in full screen”);
7. By clicking on the profile icon, the user can go to the profile;
8. The user can switch between the feed and profile screens using the tab bar.

## View image in full screen

From the feed, the user can go to view the image in full screen and share it.

**Screen contains:**

1. Enlarged image to the borders of the phone;
2. Return to previous screen button;
3. A button to upload an image and with the ability to share it.

**Algorithms and available actions:**

1. When opening an image in full screen, the user sees the image stretched to the edges of the screen. The image is centered;
     1. If the image cannot be loaded and shown, the user sees a placeholder;
     2. If a response to the request is not received, a system alert appears with an error;
2. By clicking the Back button, the user can return to the feed viewing screen;
3. Using gestures, the user can move around the stretched image, zoom and rotate the image. The image is fixed in the selected position;
     1. If gestures for zooming or rotating an image are not configured, these actions will not be available;
4. When you click the Share button, a system menu pops up in which the user can upload an image or share it;
     1. After completing the action, the menu is hidden;
     2. The user can close the menu by swiping down or by clicking on the cross;
     3. If opening the system menu when you click on the “upload or share image” button is not configured, it will not be shown;

## View user profile

The user can go to their profile to view profile information or log out.

**Profile screen contains:**

1. Profile data;
     1. User's photo;
     2. User name and username;
     3. Information about yourself;
2. Button to exit profile;
3. Tab bar;

**Algorithms and available actions:**

1. Profile data is loaded from your Unsplash profile. Profile data cannot be changed in the application;
     1. If the profile data is not pulled up from Unsplash, then the user sees a placeholder instead of an avatar. Username and name are not displayed;
2. By clicking on the logout button, the user can exit the application. A system alert pops up confirming exit;
     1. If the user clicks “Yes”, he is logged out and the authorization screen opens;
         1. If the actions with the “Yes” button are not configured or configured incorrectly, then when clicked, the user will not log out and will be taken to the authorization screen;
     2. If the user clicks "No", then he is returned to the profile screen;
     3. If the alert is not configured, then when you click on the logout button, nothing happens, the user cannot log out;
3. The user can switch between the feed and profile screens using the tab bar.

# Extended version

## Adding an image to favorites

In the advanced version of the application, when clicking on Like, the user adds the image to his favorites. Favorites are displayed in the user's profile.

1. When you click on the Like button (gray heart), the application makes a request to add the image to your favorites (without showing the loading indicator). If the request is successful, the icon changes state and the image is added to favorites;
     1. If the like request is unsuccessful, the icon does not change its state. The image is not added to favorites;
     2. If the request to add to favorites is unsuccessful, the icon does not change its state. There is no like;
2. By clicking the Like button (red heart) again, the user can remove the image from favorites;
     1. If the request to remove a like is unsuccessful, the icon does not change its state. The image is not removed from favorites;
     2. If the request to remove an image from favorites is unsuccessful, the icon does not change its state. The like is not deleted;
3. User can add an image to favorites when viewing the image in full screen. The extended version adds a like icon;
4. The user can view favorites in the profile. Favorites are displayed below the user data.
     1. A counter for the number of images is displayed next to the “Favorites” heading;
     2. When scrolling down and up, the user can view the feed with selected photos. Profile data is not recorded and is hidden when scrolling;
         1. If the image has not yet loaded, the system loader is displayed to the user;
         2. If the image cannot be loaded, the user sees a placeholder instead of an image;
         3. If there are no photos, then the user sees a placeholder;
     3. By clicking on the Like button, the user can remove the image from favorites. In the main feed, the like will also be deleted;
     4. The user can view the image in full screen;
