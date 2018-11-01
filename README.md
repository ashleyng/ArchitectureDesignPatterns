# Architecture Design Patterns

A simple application using [NASA's A Picture of the Day API](https://api.nasa.gov/api.html#apod). It pulls an `X` number of random photos and displays them in a TableView. You can tap on a photo to "favorite" or "unfavorite" it (just moves it between the first and second sections of the TableView), and you can tap on the accessory icon to see more dtails about the photo.

A blog post was written on each pattern (except MVC, since each post is comparing itself to MVC) show casing what I learned, the tutorials I used, and the articles I read about a given pattern.

## Patterns Used
  - Model-View-Controller (MVC)
  - [Model-View-ViewModel (MVVM)](https://medium.com/@shley_ng/architecture-design-patterns-mvvm-aa8fb0ec8f1e)
  - [Model-View-Presenter (MVP)](https://medium.com/@shley_ng/architecture-design-patterns-mvp-da44690a8d69)
  - [Clean Architecture or VIPER](https://medium.com/@shley_ng/architecture-design-patterns-viper-d8ade20795de)
  - [Flux](https://medium.com/@shley_ng/architecture-design-patterns-flux-7b6eb6ea2635)
  - [Facade](https://medium.com/@shley_ng/architecture-design-patterns-facade-b1af5ae1b2c0)
 
## Build and Run Applications
  1. [Generate an API key](https://api.nasa.gov/index.html#apply-for-an-api-key)
  2. Plug in API key into the `ApiFetcher.swift` file you want to run
  3. Build and Run
