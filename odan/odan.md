この記事は、 [OIT Advent Calendar 2017](https://adventar.org/calendars/2102)の2日目の記事です。

# 前置き
元々OIT Advent Calendarに弊学の梅田キャンパスを「がっこうたんけんした話」を書くつもりでしたが外が寒くてダメでした．何か記事を書くネタを考えたところ最近zshを使い始めたのでそのことを書くことにしました(偶然にも2日連続シェル環境の記事になった)．

# dotfiles
最初に貼っておくとdotfilesは以下にあります

[https://github.com/odanado/dotfiles:embed:cite]

# Docker
また以下のコマンド群をコピペするだけで僕のzshを試せます！
```
docker run --rm -it odanado/zsh zsh
./install.sh && ./deploy.sh
source ~/.zshenv && source ~/.zshrc
```

# 動機
周りに影響されてfishを触ってみたところ，デフォルトで入っているauto suggestion機能がとても便利に感じました．ほぼ何もカスタマイズされてないbashで作業をするのは目に見えない時間を失っているようで嫌だったので，bashを辞めることを決意しました．  
乗り換えるshellを選ぶ上で前から気になっていたzshと，周りの人が使っているfishで悩みましたが，zshの方が色々カスタマイズできてネット上に情報が多そうだったので，zshを選びました．

# プラグインマネージャ
まず最初にプラグインマネージャを選びました． `Prezto` や `oh-my-zsh` や `Antigen` などもありましたが， `zplug` がいいとの情報が多かったので `zplug` を選択しました．後述しますが実際使ってみて最高でした

# インストールしたプラグイン
## zsh-users系
目についたやつを入れていきました

- zsh-users/zsh-syntax-highlighting
- zsh-users/zsh-completions
- zsh-users/zsh-autosuggestions
- zsh-users/zsh-history-substring-search

## peco
pecoはリアルタイムgrepみたいなコマンドです．GO言語で実装されていて厳密にはzshのプラグインというわけではないんですが， `zplug` だとこういったものも `zplug "peco/peco", as:command, from:gh-r` でインストールすることが可能です．この柔軟性が最高だと思いました．

## ghq
これまでは `~/git` 以下にひたすらgit cloneしたリポジトリを集めてましたが，ghqを使えば管理が楽になります．これも `zplug` を使って `zplug "motemen/ghq", as:command, from:gh-r` でインストールできます．

## anyframe
pecoと連携するためのプラグインです．ほしい関数が用意されているので使うのにキーバインドやaliasを設定するだけで使えるようになって便利．

## powerline
ターミナルのステータスバー？をかっこよくするやつ． `zplug` は他人のzshファイルを読み込むこともできて， `zplug "powerline/powerline", use:"powerline/bindings/zsh/powerline.zsh"` でインストール可能です(ほんと最高)．
デフォルトのconfigだとかっこいい三角形を表示するためにpowerline用のフォントをインストールする必要があります．しかし三角形を表示するためにフォントをインストールのは大げさだと思い，configで`"default_top_theme": "ascii"` としています．他にも設定を弄って最終的にこんな表示になりました．
[f:id:odan3240:20171202222956p:plain]


# その他設定
## ヒストリ
どうやらデフォルトではヒストリを保存しないぽいので設定しました

```bash
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=500000
setopt hist_ignore_all_dups # 同じコマンドをヒストリに保存しない
setopt hist_reduce_blanks # 無駄なスペースを消してヒストリに保存する
setopt share_history # ヒストリを共有
```

## ssh-agent関係
tmux内でもssh-agentが使えるように以下の記事の設定をコピペしました

[https://qiita.com/sonots/items/2d7950a68da0a02ba7e4:embed:cite]

# CIとか
TravisCIとDockerを使ってgithubにpushされるたびに，`zplug`でのプラグインのインストールが成功することと，`zshenv`及び`zshrc`の読み込みが成功することをテストするようにしました．本当はちゃんど動作するところまでテストしたいと思っていましたが方法がわからず，ないよりマシの精神でインストールとロードまでをテストしています．この辺の知識がある方がいれば教えていただきたいです(あとneovimの起動もテストしたい)．

# おわりに
bashからzshに乗り換えてインストールしたプラグインや設定を紹介しました．今回zshに乗り換えたことでシェル環境の快適度が増して個人的にとても満足しています．
zshにはこんな便利なプラグインがあるよ！とかこの設定書くと便利だよ！などの情報をお持ちの方はぜひ教えてください．
