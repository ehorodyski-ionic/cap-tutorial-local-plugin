# Using the Plugin API

Before we work on implementing the `ScreenOrientation` plugin for each platform, let's build out the user interface to our e-signature requirement. This UI will make calls to our plugin so we can easily test as we build out implementations for each platform.

## User Interface

Since the focus of this walkthrough is building a Capacitor plugin, not building an Ionic Framework application, let's take the finished versions of `src/pages/Home.tsx` and `src/pages/Home.css` and copy and paste their contents into your project:

- [src/pages/Home.tsx](/src/pages/Home.tsx)
- [src/pages/Home.css](/src/pages/Home.css)

We'll review relevant portions of code from `Home.tsx` in the section below.

## Calling the `ScreenOrientation` Plugin
