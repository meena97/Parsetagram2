# Project 3 - *Parsetagram*

**Parsetagram** is a photo sharing app using Parse as its backend.

Time spent: **~40** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite Scrolling
- [x] User can tap a post to view post details, including timestamp and creation
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user.

The following **optional** features are implemented:

- [x] Show the username and creation time for each post
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse.
- [x] User Profiles:
   - [x] Allow the logged in user to add a profile photo
   - [x] Display the profile photo with each post
   - [x] Tapping on a post's username or profile photo goes to that user's profile page
- [x] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [x] Run your app on your phone and use the camera to take the photo


The following **additional** features are implemented:

- [x] List anything else that you can get done to improve the app functionality!
- Added a couple of animations
- Added a launch screen and an App icon
- Added a "Search" and "Activity" page as well, but those are there just for a better UI experience. I ran out of time to add any functionality :(
- Added a "Direct Messages" page, but again, it is there for a better UI experience.
- Added an "Options" page, that allows the user to "Log Out". A couple of the other buttons also have some functionality. For example, when you click on the buttons in the "ABOUT" or "SUPPORT" sections, it takes you to the corresponding webpage.
- Added a label that keeps track of the number of comments per post (in addition to the number of likes)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Implementing "follower" and "following" features.
2. Implementing the activity and search bar functionality.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

**Sign-Up, Login, Logout**

<a href="http://imgur.com/paZXAzL"><img src="http://imgur.com/paZXAzL.gif" title="source: imgur.com" /></a>

**user persists, post picture, view user posts**

<a href="http://imgur.com/IDC0w9C"><img src="http://imgur.com/IDC0w9C.gif" title="source: imgur.com" /></a>

**Comments, Like/Unlike, Infinite Scrolling, Redirect to user profile, Preview Image** (also shows an image taken from camera)

<a href="http://imgur.com/kqeoBko"><img src="http://imgur.com/kqeoBko.gif" title="source: imgur.com" /></a>

*The GIF wouldn't load, so I shared it at this [link](http://imgur.com/kqeoBko)*

**Switch between all tabs**

<a href="http://imgur.com/ijOgVCh"><img src="http://imgur.com/ijOgVCh.gif" title="source: imgur.com" /></a>

**Direct Messages Page & Settings Tab**

<a href="http://imgur.com/Gb1CE5n"><img src="http://imgur.com/Gb1CE5n.gif" title="source: imgur.com" /></a>


GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Parse]
- For the heart "like" animation, I found a helpful open sourced class.


## Notes

Describe any challenges encountered while building the app.
- There were so many features to keep track off, I sometimes got lost in the details/implementations.
- I had a hard time with storing and posting comments/likes, and also storing the profile pictures.

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
