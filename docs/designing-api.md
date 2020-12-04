# Designing the Plugin API

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