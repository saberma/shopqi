Comment = Backbone.Model.extend
  name: 'comment'

  toJSON : ->
    #得删除article关联,要不然无法保存,报ActiveRecord::AssociationTypeMismatch
    this.unset 'article', silent: true
    attrs = this.wrappedAttributes()


