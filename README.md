## BitPrice - An example of using MVVM to fetch and display Bitcoin prices
* **Project Name:** BitPrice
* **Author:** Michael T. Jones
* **Code Coverage:** 94%
* **Compiler:** Xcode 12.2 (min: 11.7)
* **Language:** Swift 5
* **Target Device:** Universal iOS (iPhone + iPad)
* **Original Completion Date:** March 8, 2021

### About the project:
The project uses an MVVM-C architecture pattern. The main benefit of the root MVVM pattern over the standard MVC is to maximize testing 
surface, insure view state accurately reflects any changes model state and to a lesser extent, discourage developers from dumping the majority 
of their code into the ViewController. ...although, not to go off the rails on a tangent but I personally believe that if your ViewControllers are 
becoming too massive, you're probably not approaching MVC in the best manner to begin with but that is a discussion for another time and place ;)

The "C" portion of MVVMC mainly adds an extra abstraction layer between the AppDelegate and your ViewControllers, separating navigation logic 
from individual view logic, making it easier to modify the flow or screen sequence of the app without modifying individual View or ViewController code.
This separation is not very beneficial in a small example app like this one but in larger projects with frequently changing product specs, it can be quite 
useful.  

Lastly, the solution uses no third-party frameworks or libraries.  I rolled my own network client around URLSession and implemented a binding pattern 
between Views and their associated ViewModels using a very simple `Observer` pattern and clever use of Swift's `didSet` event.
