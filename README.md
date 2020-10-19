# Fugu

"[Fugu](https://en.wikipedia.org/wiki/Fugu) can be lethally poisonous due to its tetrodotoxin, meaning it must be carefully prepared to remove toxic parts and to avoid contaminating the meat."

##

Strongly typed yet dynamic property and dependency management for Swift.

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
let default = container[SomeProperty.self]
container[SomeProperty.self] = 7
let previouslySet = container[SomeProperty.self]

// You can improve that by extending PropertyContainer with your property like so:
extension PropertyContainer {
  
  var someProperty: SomeProperty {
    get { self[SomeProperty.self] }
    set { self[SomeProperty.self] = newValue }
  }
}
// Which gives you more natural access
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

let answerFromFeature = container.someFeature.answer

// Additionally to all of those features you can
// observe both property and feature changes in container
let cancelation = container.observe(SomeProperty.self) { newValue in
  // get notified on each value change
}
// You can cancel observation at any time using returned cancellable

```

## License

Copyright 2020 Miquido

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
