# RedMachine
- [Running RedMachine](#running-redMachine)
- [MVVM Architecture](#mvvm-architecture)
- [](#)
- [To Do List](#to-do-list)



## Running RedMachine
Make sure you have access to the `RedMachine` repo.
Make sure you have installed gem and pod.

```sh
$ git clone https://github.com/Dingli-Xu-Accenture/RedMachine.git
$ cd RedMachine
$ pod install
$ open RedMachine.xcworkspace
```

Then run the 'RedMachine' target in Xcode.

## MVVM Architecture
### ViewController: `VC`
**Role:** (a) **bindings**, and (b) **Navigation** logic. 


### ViewModle: `VM`
**Role:**  (a) **Managing display state** and (b) **Responding to interactions**.  

### Views:  `V` 
**Role:** (a)**UI components** and (b) **Decorative**.

## To Do List
- Dependency Injection
- Tests





