<!--
title: Hexo多机同步
date: 2016-11-29 20:26:31
tags: 
- Hexo
- Git
-->
### Hexo多机同步
Date: 2016-11-29 20:26:31
在单位想写个blog，庆祝下自己虚拟机完成，结果发现居然干不了。原因很简单, Hexo没有吧我的.md文件同步到github上，它同步的是生成的文件。我要向继续工作，没有这些md，原来的blog就都不再了:-(.

咋整？Easy, 来个branch不就行了？

现在git hub上来一个新branch, 命名为hexo
在我blog的工作目录下（就是hexo init的目录）
- git init
- git remote add origin "git@github.com: zhuzhigao/zhuzhigao.github.io.git"
- git pull origin hexo
 
接下来问题来了，这个把我已经push上去的那些页面都拿下来了，在hexo branch下我不想要这些，只想存markdown. 咋整?删除呗。

问题又来了，如果 git status，工作目录下还有好多文件我不想加的. Easy, 创个.gitignore无视之。
- git add .
- git commit -m "initial release of markdowns"
- git push origin hexo

搞定！记得hexo的_config.yml里面的git branch还是master，这样最后部署生成的页面还是在master上。
最后branch结果是:
- master: for archive deployed pages
- hexo: for archive markdown files
<!-- more -->
明天就等着去单位把hexo里的markdown拿下来，每次新加blog把markdown上传到hexo branch就行了。
