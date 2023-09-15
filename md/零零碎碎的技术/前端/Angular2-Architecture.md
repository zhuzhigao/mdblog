<!--
title: Angular2 Architecture
date: 2016-12-06 14:36:30
tags:
- Angular2 
- Architecture
- Web
-->

## Angular2 HL Picture
![image](https://angular.io/resources/images/devguide/architecture/overview2.png)

## Modules
While the root module may be the only module in a small application, most apps have many more feature modules, each a **cohesive block of code dedicated to an application domain, a workflow, or a closely related set of capabilities**.
<!-- more -->

- An Angular module, whether a root or feature, is a class with an @NgModule decorator.
- declarations - the view classes that belong to this module. Angular has three kinds of view classes: components, directives, and pipes.
- exports - the subset of declarations that should be visible and usable in the component templates of other modules.
- imports - other modules whose exported classes are needed by component templates declared in this module.
- providers - creators of services that this module contributes to the global collection of services; they become accessible in all parts of the app.
- bootstrap - the main application view, called the root component, that hosts all other app views. Only the root module should set this bootstrap property.

```javascript
import { NgModule }      from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
@NgModule({
  imports:      [ BrowserModule ],
  providers:    [ Logger ],
  declarations: [ AppComponent ],
  exports:      [ AppComponent ],
  bootstrap:    [ AppComponent ]
})
export class AppModule { } 
```
## Components
A component controls a patch of screen called a view. You define a component's application logic—what it does to support the view—inside a class.

```javascript
export class HeroListComponent implements OnInit {
  heroes: Hero[];
  selectedHero: Hero;
  constructor(private service: HeroService) { }
  ngOnInit() {
    this.heroes = this.service.getHeroes();
  }
  selectHero(hero: Hero) { this.selectedHero = hero; }
}
```

## Templates
You define a component's view with its companion template. A template is a form of HTML that tells Angular **how to render** the component.
```html
<h2>Hero List</h2>
<p><i>Pick a hero from the list</i></p>
<ul>
  <li *ngFor="let hero of heroes" (click)="selectHero(hero)">
    {{hero.name}}
  </li>
</ul>
<hero-detail *ngIf="selectedHero" [hero]="selectedHero"></hero-detail>
```

![image](https://angular.io/resources/images/devguide/architecture/component-tree.png)

## Metadata
Metadata tells Angular **how to process a class**.
To tell Angular that HeroListComponent is a component, attach metadata to the class.
```javascript
@Component({
  moduleId: module.id,
  selector:    'hero-list',
  templateUrl: 'hero-list.component.html',
  providers:  [ HeroService ]
})
export class HeroListComponent implements OnInit {
/* . . . */
}
```
Metadata associates Component with Template.

## Data binding
Angular supports data binding, a mechanism for coordinating parts of a template with parts of a component. Add binding markup to the template HTML to tell Angular** how to connect **both sides.

![image](https://angular.io/resources/images/devguide/architecture/databinding.png)

```html
<li>{{hero.name}}</li>
<hero-detail [hero]="selectedHero"></hero-detail>
<li (click)="selectHero(hero)"></li>
```
{ { } } and [] one way binding, from component to template
(), one way binding, from template to component, for event
[()] two way bindings. not recommended. 

Data Binding is also an important way of communicating between parent and child.
![image](https://angular.io/resources/images/devguide/architecture/parent-child-binding.png)

## Directives

A directive is a class with directive metadata. In TypeScript, apply the @Directive decorator to attach metadata to the class.

A component is a directive-with-a-template; a @Component decorator is actually a @Directive decorator extended with template-oriented features.

A @Component requires a view whereas a @Directive does not.

Two other kinds of directives exist: **structural** and attribute directives.

Structural directives alter layout by adding, removing, and replacing elements in DOM. Like ngFor and ngIf, like  ngStyle and ngClass.

Write a component when you want to create **a reusable set of DOM elements of UI with custom behaviour**. Write a directive when you want to **write reusable behaviour** to supplement existing DOM elements.

## Services
 A service is typically a class with a narrow, well-defined purpose. It should do something specific and do it well. There is nothing specifically Angular about services.
 
 ```javascript
 export class Logger {
  log(msg: any)   { console.log(msg); }
  error(msg: any) { console.error(msg); }
  warn(msg: any)  { console.warn(msg); }
}
```

**A component's job is to enable the user experience and nothing more. It mediates between the view (rendered by the template) and the application logic (which often includes some notion of a model). A good component presents properties and methods for data binding. It delegates everything nontrivial to services.**

## Dependency injection
Angular uses dependency injection to provide new components with the services they need.
```javascript
constructor(private service: HeroService) { }
```
An injector maintains a container of service instances that it has previously created. If a requested service instance is not in the container, the injector makes one and adds it to the container before returning the service to Angular. 

![image](https://angular.io/resources/images/devguide/architecture/injector-injects.png)

You must have previously registered a provider of the HeroService with the injector. You can register providers in modules or in components.
```javascript
providers: [
  BackendService,
  HeroService,
  Logger
]
```
