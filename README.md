# Fugu

"[Fugu](https://en.wikipedia.org/wiki/Fugu) can be lethally poisonous due to its tetrodotoxin, meaning it must be carefully prepared to remove toxic parts and to avoid contaminating the meat."

## What?

Strongly typed yet dynamic property and dependency management for Swift. Here is a quick example how it looks like:

```swift
// Get container instance...
let container = Container()
// ...and access some feature or property, it will be initialized if needed.
// Here we use timestamp - access current system time - we are able to easily access it...
let timestamp = container.timestamp.now
// ...and swap it if needed for mocking or testing.
container.timestamp = .constant(0)
// Then you use the new one through container in each places at once.
let constant = container.timestamp.now
```

## Why?

Dependency and state management can be hard to be done right. It requires a lot of thought and code or becomes messy. Fugu aims to partially solve that problem by providing convenient interface and management tools to make it a lot easier and require least lines of code possible.

There are two main use cases for Fugu: dependency and dynamic property management.
For dependency management it is intended to be used as thin, managable layer providing abstractions for all external systems and IO. It is easy to pass around, build even complex initialization trees for dependencies and swap each element selectively if needed.
Property management allows easy access to configuration including these used in initialization of features. It can be also used for passing shared data around application in easy, managable and safe way.

## How?

Containers manages access to properties and features. It identies those by its types. Each type defines unique key used to store associated value. Properties require default value (which can be nil for optional value types) while Features require definition of its initialization. Those simple reqirements allow passing around lazily initialized parts of system while keeping control about all its aspects.

Here is some more detailed example, explaining how to create own properties and features:

```swift
// Define property and its value type, it can be property itself.
enum SomeProperty: Property {
  // All you need is to give it some default value.
  // It can be nil for optionals.
  static var defaultValue: Int = 42
}

// Then get some property container...
let container = Container()
// ...and access property value
let defaultValue = container[SomeProperty.self]
container[SomeProperty.self] = 7
let previouslySet = container[SomeProperty.self]

// You can improve that by extending PropertyContainer with your property like so:
extension PropertyContainer {
  
  var someProperty: SomeProperty {
    get { self[SomeProperty.self] }
    set { self[SomeProperty.self] = newValue }
  }
}
// Which gives you more natural and fluent access
let value = container.someProperty // accessing same property as before
container.someProperty = 1 // and you can also set values

// You can also define lazily initialized features
// which will be loaded in container context.
// Feature instance type can be also any type or Feature itself.
struct SomeFeature: Feature {
  // Here we use some property as example
  var answer: Int
  // All you need is to define how to initialize feature instance
  // Since you have access to container you can use any property
  // or other feature to initialize 
  // It can be a nice solution for dependency injection since you can
  // always swap implementation in needed
  static func load(in container: FeatureContainer) -> SomeFeature {
    .init(answer: container[SomeProperty.self])
  }
}
// Then you can access it in the same way as property
// and extend FeatureContainer to give it a nicer access
extension FeatureContainer {
  
  var someFeature: SomeFeature {
    get { self[SomeFeature.self] }
    set { self[SomeFeature.self] = newValue }
  }
}
// Here it is - lazily initialized, using other values from container
let answerFromFeature = container.someFeature.answer

// Additionally you can observe both property and feature changes in container
let cancelation = container.observe(SomeProperty.self) { newValue in
  // get notified on each value change
}
// You can cancel observation at any time by using returned cancellable

```

Each Container instance contains its own store for properties and features. Please make sure you deallocate unused ones or use single container to share exact same instances. The same property or feature is initialized independently in each container.

## License

Copyright 2020 KaQu

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
