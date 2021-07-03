[git官方中文教程](https://git-scm.com/book/zh/v2)

![git](https://gitee.com/Jolsonz/jolson-photo/raw/master/image/git.jpg)

## 简单操作

```bash
$ git init # 初始化仓库
$ git add . # 添加所有文件
$ git commit -m "添加 README.md 文件" # 提交并备注信息
[master (root-commit) 0205aab] 添加 README.md 文件
1 file changed, 1 insertion(+)
create mode 100644 README.md

# 提交到 Github
$ git remote add origin git@github.com:tianqixin/runoob-git-test.git #与远程仓库关联
$ git push origin master #推送
```

注意`git remote`之前要先把自己的电脑关联到github账户，用SSH密匙，这部分可百度。

### origin含义

默认情况下，origin指向的就是你本地的代码库托管在Github上的版本。

> 就是origin就代表后面那个URL，是那个URL的别名

```bash
$ git remote -v
origin https://github.com/user1/repository.git (fetch)
origin https://github.com/user1/repository.git (push)
```

也就是说git为你默认创建了一个指向远端代码库的origin（因为你是从这个地址clone下来的，或者push上去的）



用户user2 fork了你个repository，那么他的代码库链接就是这个样子

```bash
https://github.com/user2/repository

#那么它的信息不一样
$ git remote -v
origin https://github.com/user2/repository.git (fetch)
origin https://github.com/user2/repository.git (push)
```



如果user2（另一个用户）想加一个**远程指向你的代码库**，他可以在控制台输入

```
$ git remote add upstream https://github.com/user1/repository.git

$ git remote -v
origin https://github.com/user2/repository.git (fetch)
origin https://github.com/user2/repository.git (push)
upstream https://github.com/user1/repository.git (push)
upstream https://github.com/user1/repository.git (push)
```

增加了指向user1代码库的upstream，也就是之前对指向位置的命名。

> 我是这么理解：
>
> 指向user1仓库的链接`upstream`，如果user1更新了，user2可以pull下来。
> 但是如果它是copy的`origin`，那不可能太行，相当于自己建立了一个副本。

### git push -u的u参数的含义

```
$ git push origin
```

上面命令表示，将当前分支推送到origin主机的对应分支。

如果当前分支只有一个追踪分支（例如origin)，那么主机名可以省略。

```
$ git push origin
```

如果当前分支与多个主机存在追踪关系，那么这个时候**-u选项会**指定一个默认主机，这样后面就可以不加任何参数使用git push。

```
$ git push -u origin master
```

上面的命令将本地的master分支推到origin主机内，同时设定origin为默认主机，后面就可以不加任何参数的使用`git push`了（估计是默认把master推到origin了）



## 分支的新建与合并

[参考](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E6%96%B0%E5%BB%BA%E4%B8%8E%E5%90%88%E5%B9%B6)

```bash
$ git checkout -b test #Switched to a new branch "test"
#"实际上上面的是两条命令的缩写"
$ git branch test #创建test
$ git checkout test #移动到test分支

# 然后add,commite后push
$ git push -u origin test #注意这里分支变了。

# 切换回 master 分支
$ git checkout master #Switched to branch 'master' 
```

请牢记：当你切换分支的时候，Git 会重置你的工作目录，使其看起来像回到了你在那个分支上最后一次提交的样子。 Git 会自动添加、删除、修改文件以确保此时你的工作目录和这个分支最后一次提交时的样子一模一样。

> 注意，你在test分支做的修改，新建的文件，在切回另一个分支之后，比如master。会全部丢失，变成master当时的样子。只有重新checkout成test，或者分支合并才可以看到哪些文件。

```bash
#合并分支 test->master
$ git checkout master
$ git merge test #先切到想要合成的分支，然后把一个分支merge到该分支

#删除本地分支test
$ git branch -d test  
Deleted branch hotfix (3a0874c).

#查看所有分支
$ git branch -a

#删除远程分支test
$ git push origin --delete test  #注意，不能在该分支下删除远程分支，要先切到其它分支
```

> 你应该注意到了“快进（fast-forward）”这个词。 由于你想要合并的分支 `test` 所指向的提交 `C4` 是你所在的提交 `C2` 的直接后继， 因此 Git 会直接将指针向前移动。换句话说，当你试图合并两个分支时， 如果顺着一个分支走下去能够到达另一个分支，那么 Git 在合并两者的时候， 只会简单的将指针向前推进（指针右移），因为这种情况下的合并操作没有需要解决的分歧——这就叫做 “快进（fast-forward）”。



### 遇到冲突时的分支合并

如果你在两个不同的分支中，对同一个文件的同一个部分进行了不同的修改，Git 就没法干净的合并它们。

此时 Git 做了合并，但是没有自动地创建一个新的合并提交。 Git 会暂停下来，等待你去解决合并产生的冲突。 你可以在合并冲突后的任意时刻使用 `git status` 命令来查看那些因包含合并冲突而处于未合并（unmerged）状态的文件：

```bash
<<<<<<< HEAD:index.html
<div id="footer">contact : email.support@github.com</div>
=======
<div id="footer">
 please contact us at support@github.com
</div>
>>>>>>> iss53:index.html
```

如果你想使用图形化工具来解决冲突，你可以运行 `git mergetool`，该命令会为你启动一个合适的可视化合并工具，并带领你一步一步解决这些冲突

等你退出合并工具之后，Git 会询问刚才的合并是否成功。 如果你回答是，Git 会暂存那些文件以表明冲突已解决： 你可以再次运行 `git status` 来确认所有的合并冲突都已被解决

如果你对结果感到满意，并且确定之前有冲突的的文件都已经暂存了，这时你可以输入 `git commit` 来完成合并提交。 

> 当然你也可以强行合并某一个分支。这方面自己查

## 打标签

==标签的版本不能更改，起码更改了之后不会保存这个版本，这是它和分支区分开的原因==

Git 可以给仓库历史中的某一个提交打上标签，以示重要。 比较有代表性的是人们会使用这个功能来标记发布结点（ `v1.0` 、 `v2.0` 等等）

### 列出标签

```bash
$ git tag
v1.0
v2.0
```

如果只对 1.8.5 系列感兴趣，可以运行：

```bash
$ git tag -l "v1.8.5*"
v1.8.5
v1.8.5-rc0
v1.8.5-rc1
v1.8.5-rc2
v1.8.5-rc3
v1.8.5.1
v1.8.5.2
v1.8.5.3
v1.8.5.4
v1.8.5.5
```

### 创建标签

Git 支持两种标签：轻量标签（lightweight）与附注标签（annotated）。

轻量标签很像一个**不会改变的分支**——它只是某个特定提交的引用。

而附注标签是存储在 Git 数据库中的一个完整对象， 它们是可以被校验的，其中**包含打标签者的名字、电子邮件地址、日期时间， 此外还有一个标签信**息，并且可以使用 GNU Privacy Guard （GPG）签名并验证。 

通常会**建议创建附注标签**，这样你可以拥有以上所有信息。但是如果你只是想用一个临时的标签， 或者因为某些原因不想要保存这些信息，那么也可以用轻量标签。

#### 附注标签

最简单的方式是当你在运行 `tag` 命令时指定 `-a` 选项：

```bash
$ git tag -a v1.4 -m "my version 1.4"
$ git tag
v0.1
v1.3
v1.4
```

`-m` 选项指定了一条将会存储在标签中的信息。 如果没有为附注标签指定一条信息，Git 会启动编辑器要求你输入信息。

通过使用 `git show` 命令可以看到标签信息和与之对应的提交信息：

```bash
$ git show v1.4
tag v1.4
Tagger: Ben Straub <ben@straub.cc>
Date:   Sat May 3 20:19:12 2014 -0700

my version 1.4

commit ca82a6dff817ec66f44342007202690a93763949
Author: Scott Chacon <schacon@gee-mail.com>
Date:   Mon Mar 17 21:52:11 2008 -0700

    changed the version number
```

#### 轻量标签

另一种给提交打标签的方式是使用轻量标签。 轻量标签本质上是将提交校验和存储到一个文件中——没有保存任何其他信息。

创建轻量标签，不需要使用 `-a`、`-s` 或 `-m` 选项，只需要提供标签名字

```bash
$ git tag v1.4-lw
$ git tag
v0.1
v1.3
v1.4
v1.4-lw
v1.5
```

这时，如果在标签上运行 `git show`，你不会看到额外的标签信息。 命令只会显示出提交信息

### 后期打标签

你也可以对过去的提交打标签。 假设提交历史是这样的：

```bash
$ git log --pretty=oneline
5c6d61d261f4959e4ff11d17babf038a47d041c3 每日一题
a5808f22788318ce1741565d872ee3e59bde5a50 2020年最后一天的每日一题
6e1abf7095d53b2913cbc0f3c7c3893174264e7c 每天就贪心，DP呗
18e1ecae86792e7d5b3d2bc667b708f046fd6373 我TM直接退出股市
abce3b2383694e4023c2bc571129d9dfa294921a 两道题都是用栈，都挺好的
....
```

> `$ git log`也可以，就是显示的信息更多了

现在，假设在 `v0.8` 时你忘记给项目打标签，也就是在 `我TM直接退出股市` 提交。 你可以在之后补上标签。 要在那个提交上打标签，你需要在命令的末尾指定提交的校验和（或**部分校验和**）：

```console
$ git tag -a v0.8 18e1ecae8679
```

> 不加-m的话会弹出vscode让你补信息。
>
> 部分校验和真的只要复制前一段即可，不用全部复制。

```bash
$ git tag
v0.8
v1.0
```



### 共享标签（推送到远程）

默认情况下，`git push` 命令并不会传送标签到远程仓库服务器上。 在创建完标签后你必须显式地推送标签到共享服务器上。 这个过程就像共享远程分支一样——你可以运行 `git push origin <tagname>`。

```bash
$ git push origin v1.0
```

如果想要一次性推送很多标签，也可以使用带有 `--tags` 选项的 `git push` 命令。将会把所有不在远程仓库服务器上的标签全部传送到那里。

```bash
$ git push origin --tags
```

### 删除标签

删除掉你**本地仓库**上的标签，可以使用命令 `git tag -d <tagname>`。 例如，可以使用以下命令删除一个轻量标签：

```bash
$ git tag -d v0.8
```

注意上述命令并不会从任何远程仓库中移除这个标签，你必须用 `git push <remote> :refs/tags/<tagname>` 来更新你的远程仓库：

第一种变体是 `git push <remote> :refs/tags/<tagname>` ：

```bash
$ git push origin :refs/tags/0.8
```

上面这种操作的含义是，将冒号前面的空值推送到远程标签名，从而高效地删除它。

第二种**更直观**的删除远程标签的方式是：

```bash
$ git push origin --delete <tagname>
$ git push origin --delete v0.8
```

> 肯定第二种啊

### 检出标签

如果你想查看某个标签所指向的文件版本，可以使用 `git checkout` 命令， 虽然这会使你的仓库处于“分离头指针（detached HEAD）”的状态——这个状态有些不好的副作用：

```bash
$ git checkout v1.0
```

在“分离头指针”状态下，如果你做了某些更改然后提交它们，**标签不会发生变化**（指标签内容）， 但你的新提交将不属于任何分支，并且将无法访问，除非通过确切的提交哈希才能访问。 因此，如果你需要进行更改，比如你要修复旧版本中的错误，那么通常需要创建一个新分支

```bash
$ git checkout -b test2
```

### 比较两个标签之间的差异

```git
显示日志
git log tag1..tag2
显示代码差异
git diff tag1 tag2
```

