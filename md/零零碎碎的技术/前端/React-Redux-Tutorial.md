<!--
title: React Redux Tutorial
date: 2017-05-08 17:16:31
tags:
- Web
- React
- Redux
-->

作为AngularJS/Angular2用户，一直想了解一下React + Redux. 刚好看完了一个挺好的Training Session: [https://www.youtube.com/watch?v=MhkGQAoc7bc&list=PLoYCgNOIyGABj2GQSlDRjgvXtqfDxKm5b](https://www.youtube.com/watch?v=MhkGQAoc7bc&list=PLoYCgNOIyGABj2GQSlDRjgvXtqfDxKm5b)，就顺便记两句。
<!-- more -->

React: 使用render函数，可以说是自描述的View，并且使用State and Properties用来管理状态。 State或者Property的变更会重新render Dom树需要更新的部分 （后台使用virtual dom来判断是否需要更新）。State可以认为是Component内部的状态，Property是Component对外暴露的状态，可以影响别人，也可以被别人影响。

React跟Redux已经是公认的好基友了。 在使用Redux的时候， React更多的关注在View上，而让Redux管理状态。Flux and Redux的单向数据流使得数据流动哦你那个变得明晰， Redux的single store使得状态管理和跟踪变得容易。但是是不是所有状态都需要放到Redux中是有争议的，特别是UI状态，几个挺好的讨论。[https://github.com/reactjs/redux/issues/1385](https://github.com/reactjs/redux/issues/1385)， [http://stackoverflow.com/questions/35328056/react-redux-should-all-component-states-be-kept-in-redux-store](http://stackoverflow.com/questions/35328056/react-redux-should-all-component-states-be-kept-in-redux-store)。一种做法是当一个component的状态会影响别人的时候，放到Redux里，否则就Component自己Handle. 使用immutable store (redux)作为真正系统状态的store，然后用mutable object做和核心系统状态或者高频变更状态的store可以作为一种折中。
当然Dumb Component肯定是不会跟Redux有直接交互的。

还有就是内存消耗，我心里一直的疑问。[https://softwareengineering.stackexchange.com/questions/309452/redux-memory-consumption](https://softwareengineering.stackexchange.com/questions/309452/redux-memory-consumption)给了一个解释，保持状态的历史并没有想象中的消耗内存，不过这个的确在实际中需要考虑。对于大数据，可能需要使用Blob.

比起Angular来, Redux更Focus，本身也更简单。不过它也依赖于各种Plugin来完成需要的工作，如果把这些算上，感觉复杂度就该另说了。没有整整在完整的项目里使用过，就不妄言了。
