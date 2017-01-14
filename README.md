# Movable Type Data API for Swiftを使ってアプリを作ろう！
## はじめに  
これは、[MT東京-31バレンタインデー１ヶ月前から始めるSwiftxMT Data API](https://mt-tokyo.doorkeeper.jp/events/54596)の登壇するために作成したSwift3.0利用したiOSアプリです。  

<a href="https://mt-tokyo.doorkeeper.jp/"><img src="https://dzpp79ucibp5a.cloudfront.net/groups_logos/2674_normal_1397553576_mt-tokyo-logo.png" alt="MT東京 公式サイト" ></a>  

## 動作環境
* [Movable Type Data API v3](https://www.movabletype.jp/developers/data-api/)が利用できるサイト
* Xcode8.2以降(Swft3.0)
* CocoaPods
* iOS10以降がインストールされたiOSデバイス（iPad含む)

## 使い方

### 事前準備 
`pod install`で外部ラリブラリーを導入してください。 

### Step1.ホストとMovableType配置場所をソースコードを編集する
<img src="./img/HowToUseStep1_1.png" width="300" style="border:solid 1px #000000">  


### Step2.アプリを起動し検索バーに検索キーワードを入力する
<img src="./img/HowToUseStep2_1.png" width="150" style="border:solid 1px #000000">  

### Step3.キーボードの検索をタップする
Movable Type DataAPIを使い検索結果が一覧表示されます。  
<img src="./img/HowToUseStep3_1.png" width="150" style="border:solid 1px #000000">  

### Step4.一覧からタップすると掲載サイトがアプリ内ブラウザが起動し表示される
Movable Type DataAPIから取得したpermalinkのサイトが表示されます。  
<img src="./img/HowToUseStep4_1.png" width="150" style="border:solid 1px #000000">  

## これからつくるiPhoneアプリ開発入門 ~Swiftではじめるプログラミングの第一歩~
おすすめSwift 3.0向け入門書です。  
本ソースコードもこちらの書籍のお菓子検索アプリから応用しています。  
[公式サイト](https://swiftbg.github.io/swiftbook/)  
![](https://images-fe.ssl-images-amazon.com/images/I/51tP8W6KckL.jpg)