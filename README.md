# Walkthrough: Building a Capacitor Plugin

Native functionality can be added to a Capacitor application by leveraging Capacitor's Plugin API. Custom native code added to a Capacitor application can reside locally within the iOS and/or Android projects committed as part of source control, or can be extracted out and published as a Capacitor Plugin that can be added to any Capacitor application.

This walkthrough is a step-by-step guide to building a Capacitor Plugin. We will start off with a blank Capacitor application, then add custom native code (also known as a local plugin), and finally turn it into a true reusable Capacitor Plugin.

If you would like to skip the walkthrough and dig directly into the completed source code, you can find it in the `complete` branch of this repository.

## What are we building?

Let's play pretend. You work for an insurance company, and your application lets users store e-signatures so they can sign documents digitally. The legal team noticed that users using the app in portrait mode have really poor quality signatures. They're wondering if there's a way to force users to have their device in landscape mode in order to capture a signature.

Our plugin will implement **screen orientation** features to accomodate this request:

1. The device's current **orientation** will be detected, with differing UI for portrait or landscape mode.
2. Users will be given the option to rotate and **lock** their screen orientation to landscape mode.
3. After a signature has been added, the app will **unlock** screen orientation rotation.

We will not be building functionality to draw and capture signatures.

---

**Note:** Ionic Framework + React will be used to build the user interface of this application. If you are not familiar with React (or the Ionic Framework) that's OK! The concepts covered in this walkthrough are applicable to Capacitor applications using any TypeScript-enabled web framework.

A step by step walkthrough that shows full life cycle, creating the plugin in the existing project and then extracting into a true reusable plugin.

- start with an API for something that is supported on Android and iOS, something simple, include links to the docs for the API(s)
- create a blank starter Capacitor app w/ platforms
- design the abstraction we want, explain options (domain based abstraction vs. thin binding, etc)
  -- Discuss how much the web already does, and drive home that we don't need to build out rotation handler, etc.
- create plugin in each platform
- modify blank starter to test out the plugin in some way (though some basic calls to it)
- break out code into a reusable plugin

iOS API Documentation: https://developer.apple.com/documentation/uikit/uideviceorientation

Capacitor Docs Gaps:

- Local Web Plugin Stub
