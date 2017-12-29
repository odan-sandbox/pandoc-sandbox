# pandoc-sandbox
pandocで執筆環境を作る

# 項目の追加の仕方
- 適当な名前でディレクトリを作る (ここでは `poyo` とする)
- `poyo` 以下に `poyo.md` という名前のmarkdownファイルを作る
- `Makefile` の MD_DIRS に `poyo` を追加する
- `main.tex` に `\input{build/poyo}` を追加する

# pdfファイルの生成の仕方
```bash
docker build . -t odanado/pandoc-sandbox
docker run --user=root --rm -it -v $PWD:/home/user/work -e NB_UID=`id -u` -e NB_GID=`id -g` odanado/pandoc-sandbox run.sh make
```
