import XCTest
@testable import Fugu

final class FuguTests: XCTestCase {
  
  var container: Container!
  
  override func setUp() {
    container = Container()
  }
  
  override func tearDown() {
    container = nil
  }
  
  func test_propertyHasDefaultValue_whenNotSet() {
    XCTAssertEqual(container[TestProperty.self], TestProperty.defaultValue)
  }
  
  func test_propertyHasGivenValue_whenSet() {
    container[TestProperty.self] = 127
    XCTAssertEqual(container[TestProperty.self], 127)
  }
  
  func test_propertyHasDefaultValue_whenReset() {
    container[TestProperty.self] = 127
    container.reset(TestProperty.self)
    XCTAssertEqual(container[TestProperty.self], TestProperty.defaultValue)
  }
  
  func test_propertyHasNewValue_whenResetUsingGeneratedDefault() {
    let initialDefault = UUID.defaultValue
    container[UUID.self] = initialDefault
    container.reset(UUID.self)
    XCTAssertNotEqual(container[UUID.self], initialDefault)
    XCTAssertNotEqual(container[UUID.self], UUID.defaultValue)
  }
  
  func test_propertyObserverGetsDefaultValue_whenInitialized() {
    var observedValue: TestProperty.Value?
    _ = container.observe(TestProperty.self) { value in
      observedValue = value
    }
    _ = container[TestProperty.self]
    XCTAssertEqual(observedValue, TestProperty.defaultValue)
  }
  
  func test_propertyObserverGetsNoValue_whenCanceled() {
    var observedValue: TestProperty.Value?
    let cancelation = container.observe(TestProperty.self) { value in
      observedValue = value
    }
    cancelation.cancel()
    container[TestProperty.self] = 0
    XCTAssertNil(observedValue)
  }
  
  func test_propertyObserverGetsGivenValue_whenSet() {
    var observedValue: TestProperty.Value?
    _ = container.observe(TestProperty.self) { value in
      observedValue = value
    }
    container[TestProperty.self] = 127
    XCTAssertEqual(observedValue, 127)
  }
  
  func test_propertyObserverGetsDefaultValue_whenReset() {
    var observedValue: TestProperty.Value?
    _ = container.observe(TestProperty.self) { value in
      observedValue = value
    }
    container.reset(TestProperty.self)
    XCTAssertEqual(observedValue, TestProperty.defaultValue)
  }
  
  func test_featureHasAccessToContainer_whenInitialized() {
    XCTAssertEqual(container[TestSubfeature.self].testFeature.testProperty, TestProperty.defaultValue)
  }
}

enum TestProperty: Property {
  
  static var defaultValue: Int = 42
}

struct TestFeature: Feature {
  
  var testProperty: Int
  
  static func load(in container: FeatureContainer) -> TestFeature {
    .init(testProperty: container[TestProperty.self])
  }
}

struct TestSubfeature: Feature {
  
  var testFeature: TestFeature
  
  static func load(in container: FeatureContainer) -> TestSubfeature {
    .init(testFeature: container[TestFeature.self])
  }
}
