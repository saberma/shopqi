#encoding: utf-8
class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.integer :shop_id, comment: '所属网店'
      t.string :title, comment: '标题',null: false
      t.string :commentable, comment: '评论权限'
      t.string :handle, comment: '用于模板中的Permalink/Handle', null: false

      t.timestamps
    end
    create_table :articles do |t|
      t.integer :shop_id  , comment: '所属商店(冗余方便全文检索)'
      t.integer :blog_id  , comment: '所属博客'
      t.string :title     , comment: '标题'
      t.text :body_html   , comment: '内容'
      t.boolean :published, comment: '是否可见'                  , default: true
      t.integer :user_id  , comment: '更新人'
      t.string :author    , comment: '作者'

      t.timestamps
    end
    create_table :comments do |t|
      t.integer :article_id, comment: '所属文章'
      t.integer :shop_id, comment: '所属商店'
      t.string :status     , comment: '状态'
      t.string :author       , comment: '评论人'
      t.string :email      , comment: '邮箱'
      t.text :body      , comment: '评论内容'

      t.timestamps
    end

    add_index :blogs   , :shop_id
    add_index :articles, :blog_id
    add_index :comments, :article_id
  end

  def self.down
    drop_table :comments
    drop_table :articles
    drop_table :blogs
  end
end
