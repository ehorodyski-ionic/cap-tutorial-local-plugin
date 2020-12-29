# Code Abstraction Patterns

Before we officially cross over from web to native mobile development it would be beneficial to review some common Capacitor plugin code abstractions and pick an initial pattern to follow.

## Intro to Design Patterns

Design patterns are general, reusable solutions to common problems in software design. Design patterns aren't a programmatic solution to a problem, rather a guide or blueprint on how to abstract your code to solve reoccuring problems.

You have most likely been using design patterns even if you aren't aware of it. Angular heavily relies on the Dependency Injection and Singleton patterns. React uses the Mediator and State patterns. Push notifications on mobile devices use the Observer pattern.

Point being, you should feel empowered as a developer to use the library of design patterns to craft the code abstraction of your Capacitor plugins.

### Where can I find examples of design patterns?

Speaking developer-to-developer, I gravitate towards the following resources for examples of design patterns and how to implement them:

- [Head First Design Patterns (O'Reilly Publishing)](https://www.oreilly.com/library/view/head-first-design/0596007124/)
- [Design Patterns (Refactoring Guru)](https://refactoring.guru/design-patterns)

Personally speaking, I keep _Head First Design Patterns_ in my bookshelf and thumb through it when I need refreshers or am in the planning phases of projects (to disconnect from online distractions) and I'll browse _Refactoring Guru_ when I'm head-down writing code.

## Common Plugin Patterns

You can probably imagine the amount of plugins I've sifted through working so closely in the hybrid mobile development space. When looking through so many plugins, certain patterns emerge:

### Thin Binding

When working with simplier native APIs, thin binding works very well. Several official Capacitor plugins employ this technique, such as the [Capacitor Device plugin](https://github.com/ionic-team/capacitor-plugins/blob/main/device/ios/Plugin/DevicePlugin.swift):

```swift
@objc func getLanguageCode(_ call: CAPPluginCall) {
    let code = implementation.getLanguageCode()
    call.resolve([
        "value": code
    ])
}
```

In it's simplest form, thin binding is just mapping one API to another. When using thin binding it's wise to write two classes, one that performs the actual implementation and one that defines the plugin binding. Using the example above, the official Capacitor Device plugin contains two Swift files:

- `Device.swift` - Contains methods that perform concrete native API implemenations.
- `DevicePlugin.swift` - Calls the concrete implementations and contains any plugin specific setup.

The pairing of classes works well, should the native API implementation change no modification to the binding is required.

### Domain-Based Abstraction

Some plugin use-cases may require you to traverse multiple targeted subject areas (domains). Let's walk through an imaginary scenario:

You work for a SaaS company that provides analytics, push notifications, crash reporting, and data syncing for mobile applications. Upper management mandates that a singular Capacitor plugin must be created that provides access to all product modules.

Each one of those offerings touches different native APIs, and could be changed independently of one-another. Therefore, a logical code abstraction pattern would be to separate the plugin's code base by domain.

## So, what does this tutorial use?

As we build out the `ScreenOrientation` plugin we will make use of thin binding. Without spoiling too much it's very straight-forward and simple to natively modify orientation; applying any other pattern doesn't make much sense here.

Let's put theory to practice by writing the [iOS platform implementation](/docs/native-ios.md) of the plugin first.
