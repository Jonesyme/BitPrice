## BitPrice - An example of using MVVMC to fetch and display Bitcoin prices

* **Author:** Michael T. Jones
* **Code Coverage:** 94%
* **Language:** Swift 5
* **Compiler:** Xcode 12.2 (min: 11.7)
* **Target Device:** Universal iOS (iPhone + iPad)
* **Original Completion Date:** March 8, 2021


### About the project:
The project uses an MVVM-C architecture pattern. The main benefit of the root MVVM pattern over the standard MVC is to maximize testing surface, ensure a view's state reflects changes to underlying model state and to a lesser extent, discourage developers from dumping code into ViewControllers. ...although, not to go off the rails on a subjective tangent but I personally believe that if your ViewControllers are becoming too massive, you're probably not approaching MVC in the best manner either but that is a discussion for another time and place ;)

The "C" portion of MVVMC mainly adds an extra abstraction layer above your ViewControllers, separating navigation logic from individual view logic, making it easier to modify the flow or screen sequence of an app without modifying individual View or ViewController code.  This benefit is difficult to visualize in a small example app like this but in large projects, with frequently changing requirements, it can be quite useful.  

Lastly, the solution uses no third-party frameworks or libraries.  I rolled my own network client around URLSession and implemented a binding pattern between Views and their associated ViewModels using a simplified `Observer` pattern based on Swift’s `didSet` event on class properties.

**NOTE:** For an MVC-based approach to a similar problem, see my [BitWatch](https://github.com/Jonesyme/BitWatch) project

### Screenshots:
![SS1 - Price List](https://user-images.githubusercontent.com/6075332/116029864-3b604680-a628-11eb-9205-10aed2c741c8.png)
![SS3 - Detail Live](https://user-images.githubusercontent.com/6075332/116029920-6054b980-a628-11eb-88a7-5c98319e40f0.png)
![SS4 - Detail Close](https://user-images.githubusercontent.com/6075332/116029922-621e7d00-a628-11eb-81aa-79c762c0599f.png)
