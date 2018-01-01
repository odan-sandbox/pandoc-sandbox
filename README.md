# pandoc-sandbox
pandocで執筆環境を作る

# 項目の追加の仕方
- 適当な名前でディレクトリを作る (ここでは `poyo` とする)
- `poyo` 以下に `poyo.md` という名前のmarkdownファイルを作る
- `Makefile` の MD_DIRS に `poyo` を追加する
- `main.tex` に `\input{build/poyo}` を追加する

# pdfファイルの生成の仕方
```bash
make docker-pull
make docker-all
```

うまくいけば `main.pdf` が生成されているはず
