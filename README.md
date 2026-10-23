# [Coffee Stack Log.]
[![Image from Gyazo](https://i.gyazo.com/ffc21c6528701bf83fac03c5d019ad1c.png)](https://gyazo.com/ffc21c6528701bf83fac03c5d019ad1c)

## [アプリURL](https://www.coffeestacklog.com)


## ER図
[![Image from Gyazo](https://i.gyazo.com/5a292384d84a0c9bee15940ef0f90c7d.jpg)](https://gyazo.com/5a292384d84a0c9bee15940ef0f90c7d)

## 画面遷移図
[figma](https://www.figma.com/file/frDfOydyzsAVZaFIgzxdCp/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?type=design&node-id=0%3A1&mode=design&t=Epi3OEB0cMYuXvA5-1)

## サービス概要
Coffee Stack Log. は買ったコーヒー豆を記録し、それを使って淹れたコーヒーのレビューを投稿できるサービスです

## 想定されるユーザー層
自分好みのコーヒー豆に出会えていない人  
新しいコーヒー豆に手を出してみたいがどれがいいのかわからない人  

## サービスコンセプト

コーヒー豆を選んで買うときに以前どの種類を買ったのか記録していないと、「前に好みの豆があったけどどの商品だったのか思い出せない」といった事象や、そもそも瓶やマシンに移し替えて袋を早々に捨ててしまうと今飲んでいるコーヒーの豆の種類さえわからないと言った事態があり、自分自身も色々と豆の種類を試していた時期は前回までは覚えていてもそれ以前はわからなくなっていました。  
またコーヒーに特化してユーザー側のレビューを集約したサイトは検索した限り出てこず、実際に店舗で売られているどの豆でどの炒り具合が美味しかったなどの情報が集めづらく感じます。  
『Coffee Stack Log.』を利用し買った豆の記録し淹れたコーヒーのレビューを投稿することで、自分好みのコーヒー豆の把握、そして他ユーザーの投稿を見ることで新しく購入するコーヒー豆を選ぶ参考になればと思い考案しました。  


## 使用技術
* ruby 3.2.2
* Ruby on Rails 7.0.8
* Node.js 18.19.0
* Docker
* PostgreSQL
* Heroku
* Bootstrap 5.3.1
* Esbuild
* Stimulus
* Stimulus-autocomplete
* Sorcery
* Ransack
* Geocoder
* Slim
* CarrierWave
* Fog-aws
* Amazon S3
* Swiper

## Set up
```
git clone git@github.com:Alnoir-0011/coffee_review_app.git
docker-compose build && docker-compose up -d
docker-compose exec web rails db:migarte && docker-compose exec web rails db:seed_fu
```

## 実装している機能
* 会員登録
* ログイン
* プロフィール登録(抽出機器、グラインダー、好きな飲み方の登録)
* 他ユーザーのプロフィール閲覧
* コーヒー豆の記録
  * 購入店舗、豆のロースト具合、品種を記録可能、粉の場合は細かさを追加
  * お気に入り登録
  * 産地をおおまかに分類(グアテマラ、キリマンジャロ等)
  * 入れたコーヒーのレビュー投稿
    * 粉の細かさ、抽出機器を記録可能
* 販売店のマップ表示
  * 販売店を選択すると投稿されたレビューを表示
* レビュー閲覧
  * 他ユーザーのレビューへのいいね機能
    * 購入記録に基づくレコメンド機能
* 購入店舗、商品名のオートコンプリート
