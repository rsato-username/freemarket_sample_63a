# README

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false|
|password|string|null: false|
|tel|integer|null: false|
|description|text| |
|image|string| |
|point|integer| |
|money|integer| |
|sales|integer| |
### Association
- has_many    :items
- has_many    :likes
- has_many    :cards
- belongs_to  :exhibit
- belongs_to  :transaction
- belongs_to  :sale
- belongs_to  :user_info

## itemsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|price|integer|null: false|
|description|text|null: false|
|status|integer|null: false|
|post_money|string|null: false|
|post_region|string|null: false|
|post_day|string|null: false|
|user_id|integer|null: false, foreign_key: true|
|category_id|integer|null: false, foreign_key: true|
|brand_id|integer|null: false, foreign_key: true|
### Association
- belongs_to  :user
- has_many    :likes
- belongs_to  :category
- belongs_to  :brand
- has_many    :photos
- belongs_to  :exhibits
- belongs_to  :transactions
- belongs_to  :sales

## likesテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|string|null: false, foreign_key: true|
|item_id|string|null: false, foreign_key: true|
### Association
- belongs_to  :user
- belongs_to  :item

## categorysテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|null: false|
### Association
- has_many  :items

## brandsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many  :items

## photosテーブル
|Column|Type|Options|
|------|----|-------|
|url|string|null: false|
|item_id|integer|null:false, foreign_key: true|
### Association
- belongs_to  :item

## user_infoテーブル
|Column|Type|Options|
|------|----|-------|
|kan_familyname|string|null: false|
|kan_firstname|string|null: false|
|kana_familyname|string|null: false|
|kana_firstname|string|null: false|
|birthday|integer| |
|post_number|integer|null: false|
|prefecture|string|null: false|
|city|string|null: false|
|address|string|null: false|
|building|string| |
### Association
- belongs_to  :user

## cardsテーブル
|Column|Type|Options|
|------|----|-------|
|number|string|null: false|
|validity_year|integer|null: false|
|validity_month|integer|null: false|
|security_cord|integer|null: false|
|user_id|integer|null: false, foreign_key: true|
### Association
- belongs_to  :user

## exhibitsテーブル
|Column|Type|Options|
|------|----|-------|
|number|string|null: false|
|flag|string|null: false|
|user_id|string|null: false, foreign_key: true|
|item_id|string|null: false, foreign_key: true|
### Association
- belongs_to  :user
- belongs_to  :item

## transactionsテーブル
|Column|Type|Options|
|------|----|-------|
|evaluation|string| |
|user_id|string|null: false, foreign_key: true|
|item_id|string|null: false, foreign_key: true|
### Association
- belongs_to  :user
- belongs_to  :item

## salesテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|string|null: false, foreign_key: true|
|item_id|string|null: false, foreign_key: true|
### Association
- belongs_to  :user
- belongs_to  :item