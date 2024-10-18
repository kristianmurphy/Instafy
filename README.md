Group 21 - README
===

# Music Social Media (Using Spotify API)

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview
### Description
This app will utilize the Spotify API to connect Spotify Music listeners with each other on a new social-media platform. Users can share playlists, songs, artists, and albums onto their feeds for others to explore.

### App Evaluation
- **Category:** Social Networking / Music
- **Mobile:** Functionality would not be limited to Mobile. However, the initial implementation would be developed in mobile.
- **Story:** Users post, comment, and listen to music that come from the Spotify API.
- **Market:** Anyone could use this application.
- **Habit:** This application would be used idealy as much as other social media websites.
- **Scope:** The scope will begin as just a small group of Users. However, we wish to implement it to allow for future users to join as well.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can login.
- [x] User can share playlists using the spotify link.
- [x] User can comment on other user's posts.
- [x] User can log out.
- [x] User can select from three seperate views: Feed, Explore, and Profile.

**Optional Nice-to-have Stories**

- [x] User can pull up the spotify playlist by clicking the play button.
- [x] User can be taken to the spotify profile from the Profile tab.
- [x] User can view detailed Profile information on Profile tab, including posts made on Instafy.
- [x] User can play playlists from Feed Tab or Profile Tab.
- [x] Users comments appear instantaneously


### 2. Screen Archetypes

* Login Screen
    * User can login.
    * User can register an account.
* Home Screen
    * User can scroll through their feed.
    * User can play the album/playlist/song from the feed.
    * User can comment on posts.
* Post Screen
    * User can upload an image along with a description.
* User Screen
    * User Can view Post, playlists, following list, and an About Me page.
    * User can follow/unfollow the other user.
* Explore Screen
    * User can select any of the items listed in the explore tab to view the post.
    * User can look up artists, playlists, or profiles.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Explore Tab
* Feed Tab
* Profile Tab

**Flow Navigation** (Screen to Screen)

* Login Screen
    * => Home
* Home Screen
    * => Login Screen
    * => Post Screen
    * => Explore
    * => User
* Post Screen
    * => Home (After posting the object).
* User Screen
    * => User Screen (Additional Users).
    * => Home Screen
    * => Explore Screen
* Explore Screen
    * => User Screen
    * => Home Screen

## Wireframes
Because the group is working remotely from one another, we did not find it to be optimal to create a hand-written wireframe. Instead, We went straight for a digital wireframe using Figma to complete the wireframe. In the next section, we have an image of said wireframe.

### [BONUS] Digital Wireframes & Mockups

<img src="https://i.imgur.com/Azw3e0d.png" width=600>

### [BONUS] Interactive Prototype

## Schema 
### Models
Model: User
| Property            | Type            | Description                  |
|  --------           | --------        | -----------                  |
| username            | String          | displayed name of the user   |
| posts               | Array           | an array of previous posts   |
| playlists           | Array           | an array of created playlists|
| bio                 | String          | description of the user      |

Model: Post
| Property            | Type            | Description                                        |
|  --------           | --------        | -----------                                        |
| objectId            | String          | unique id for the user post (default field)        |
| author              | Pointer to User | album/playlist/song author                        |
| Album/Playlist/Song | File            | album/playlist/song that user posts               |
| caption             | String          | album/playlist/song caption by author             |
| commentsCount          | Number            | number of comments that has been posted to an post|
| likesCount          | Number            | number of likes for the post                      |

Model: Comment
| Property            | Type            | Description                                    |
|  --------           | --------        | -----------                                    |
| objectId            | String          | unique id for the user comment (default field)|
| author              | Pointer to User | comment author                                |
| caption             | String          | comment caption by author                     |

### Networking

Home Screen
- (Read/GET) Query all posts where followed users are authors
- (Create/POST) Create a comment under post
- (Delete) Undo comment

```
let query = PFQuery(className:"Post")

query.whereKey("author", containedIn: followedUsers)

query.order(byDescending: "createdAt")

query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
   if let error = error { 
      print(error.localizedDescription)
   } else if let posts = posts {
      print("Successfully retrieved \(posts.count) posts.")
      processPost()
   }
}
```

Explore Screen
- (Read/GET) All new posts of all users

Post Screen
- (Create/POST) Create a post with Spotify object and a written caption

User Page
- (Read/GET) Query all posts where user is author
- (Read/GET) Get lists of followers and followed users
- (Update/PUT) Update profile picture of user


# Sprint 1 Results

### Changes

- Created login, feed, and post pages
- Created Parse Database to save user information
- Added Parse and AlamoFireImage for relevant functionality in app
- Implemented Sign-in/Sign-up feature using Parse

### Goals for Next Sprint

- Sharing playlists from spotify account
- User posts can select Album/Tracks and be shown in the feed
- Users can comment on other posts

### Current Progress

![](https://i.imgur.com/BaEHFvm.gif)

# Sprint 2 Results

### Changes

- Show posts made by users
- Show comments on a post
- Updated the post creation screen

### Goals for Next Sprint

- User can post spotify albums using Spotify API
- Song/Album/Playlist can be opened in Spotify
- Clicking on albums/playlists in the explore tab brings up posts that mention it.

### Current Progress

![](https://i.imgur.com/XBclA2K.gif)

# Sprint 3 Results

### Changes

- Login using both Spotify API and Parse database
- Implemented new tabs for Explore and Profile
- Rework of Post creation screen
- Removal of Feed while it is being reworked

### Goals for Next Sprint

- Re-introduction of feed with new features
- User can post using Spotify API
- Viewing of other users profiles.
- Profile hosting User information and Explore tab featuring playlists linked to posts

### Current Progress

![](https://i.imgur.com/oSLpsEM.gif)

# Final Sprint Results

### Changes

- Explore now displays the latest album releases.
- User can now see the image after posting it.
- Profile image displays correctly.
- Feed View Re-implemented
- Profile View now shows Username, Name, Total number of followers and posts, Collection View of posts the user has made, and a link to the users account on Spotify.
- User can open playlists in both the Feed Tab and the Profile Tab
- Users comments are added to posts in real time.

### Final Progress

Feed Functionality

![](https://i.imgur.com/I5x1pQt.gif)

Post Functionality

![](https://i.imgur.com/5tkIC2n.gif)

Explore and Profile Tab Functionality

![](https://i.imgur.com/fIQ7Cq9.gif)
