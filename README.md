# Walkthrough: Building a Capacitor Plugin

Native functionality can be added to a Capacitor application by leveraging Capacitor's Plugin API. Custom native code added to a Capacitor application can reside locally within the iOS and/or Android projects committed as part of source control, or can be extracted out and published as a Capacitor Plugin that can be added to any Capacitor application.

This walkthrough is a step-by-step guide to building a Capacitor Plugin. We will start off with a blank Capacitor application, then add custom native code (also known as a local plugin), and finally turn it into a true reusable Capacitor Plugin.

If you would like to skip the walkthrough and dig directly into the completed source code, you can find it in the `complete` branch of this repository.

## What are we Building?

Let's play pretend. You work for an insurance company, and your application lets users store e-signatures so they can sign documents digitally. The legal team noticed that users using the app in portrait mode have really poor quality signatures. They're wondering if there's a way to force users to have their device in landscape mode in order to capture a signature.

Our plugin will implement **screen orientation** features to accomodate this request:

- The device's current **orientation** will be detected, with differing UI for portrait or landscape mode.
- Users will be given the option to rotate and **lock** their screen orientation to landscape mode.
- After a signature has been added, the app will **unlock** screen orientation rotation.

For our purposes we will be faking the signature pad and only focus on building out screen orientation functionality.

The `ScreenOrientation` plugin we will build will work across the web, iOS, and Android platforms.

## Getting Started

Let's create a very simple Ionic Framework + React based Capacitor application to use for this walkthrough. This application will just be one of the Ionic Framework's starter templates:

```bash
$ ionic start cap-tutorial-local-plugin --type=react --package-id=io.ionic.cs.capLocalPlugin
$ cd cap-tutorial-local-plugin
```

**Note:** Ionic Framework + React will be used to build the user interface of this application. If you are not familiar with React (or the Ionic Framework) that's OK! The concepts covered in this walkthrough are applicable to Capacitor applications using any TypeScript-enabled web framework.

Add both the iOS and Android platforms to our Capacitor application:

```bash
$ npm run build
$ ionic cap add ios
$ ionic cap add android
```

Now that we have our Capacitor application in place with platforms added, we're ready to move onto the first step of building the `ScreenOrientation` plugin: [designing the plugin's API](docs/designing-api.md).
