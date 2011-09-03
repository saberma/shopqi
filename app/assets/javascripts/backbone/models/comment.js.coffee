class App.Models.Comment extends Backbone.Model
  name: 'comment'

  toJSON : ->
    #得删除article关联,要不然无法保存,报ActiveRecord::AssociationTypeMismatch
    this.unset 'article', silent: true
    this.unset 'is_spam', silent: true
    this.unset 'is_published', silent: true
    this.unset 'is_unapproved', silent: true
    attrs = this.wrappedAttributes()


App.Collections.Comments = Backbone.Collection.extend
  model: App.Models.Comment
  url: '/admin/comments'
