App.Views.Comment.Index = Backbone.View.extend
  el: '#main'

  events:
    "change .selector": 'changeCommentCheckbox'
    "change #comment_bulk_action": 'changeCommentSelect'
    "click #select-all": 'selectAll'

  initialize: ->
    self = this
    @collection.view = this
    _.bindAll this, 'render'
    this.render()

  render: ->
    _(@collection.models).each (model) ->
      new App.Views.Comment.Show model: model

  selectAll: ->
    this.$('.selector').attr 'checked', this.$('#select-all').attr('checked')
    this.changeCommentCheckbox()

  # 评论复选框操作
  changeCommentCheckbox: ->
    checked = this.$('.selector:checked')
    all_checked = (checked.size() == this.$('.selector').size())
    this.$('#select-all').attr 'checked', all_checked
    if checked[0]
      this.$('#comments_count').text "已选中 #{checked.size()} 个评论"
      $('#comment-actions').show()
    else
      $('#comment-actions').hide()

  changeCommentSelect: ->
    operation = this.$('#comment_bulk_action').val()
    is_destroy = (operation is 'destroy')
    if is_destroy and !confirm('您确定要删除选中的评论吗?')
      $('#comment_bulk_action').val('')
      return false
    self = this
    checked_ids = _.map self.$('.selector:checked'), (checkbox) -> checkbox.value
    $.post "/admin/comments/set", operation: operation, 'comments[]': checked_ids, ->
      _(checked_ids).each (id) ->
        model = App.comments.get id
        if is_destroy
          $('#comment-actions').hide()
          App.comments.remove model
        else if operation is 'mark_spam'
          model.set status: 'spam'
        else
          model.set status: 'published'
      msg_text = if is_destroy then '删除' else '更新'
      msg "批量#{msg_text}成功!"
    $('#comment_bulk_action').val('')
    false
