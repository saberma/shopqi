App.Views.Product.Show.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #action-links a.edit-btn": "toggleEdit"
    "click #action-links a.dup-btn": "showDuplicate"
    "click #duplicate_product_submit": "duplicate"
    "click #duplicate-product .cancel": "duplicateCancel"
    "click #new-variant-link p": "newVariant" # 新增款式
    "click .closure-lightbox": 'show' # 显示图片

  initialize: ->
    Handlebars.registerHelper 'option_value', (context, block) -> # 获取款式中的option1,option2,option3等值，外围对options进行迭代，在handlebars中只能使用额外的helper实现
      [index, index_plus] = [this.index, this.index_plus]
      block(value: context["option#{index_plus}"], variant_id: context.id, index: index, index_plus: index_plus)
    # 先生成修改页面，以便查看页面获取集合名称
    new App.Views.Product.Show.Edit model: @model
    new App.Views.Product.Show.Show model: @model
    new App.Views.ProductOption.Index collection: @model.options # 显示商品选项
    new App.Views.Product.Show.Variant.Index collection: App.product_variants # 款式
    @model.bind 'change:title', (model) -> $('#product_title > a').text(model.attributes.title)
    @model.bind 'change:handle', (model) -> $('#product_title > a').attr('href', "/products/#{model.attributes.handle}")
    # 修改商品选项后要重新渲染所有款式
    @model.bind 'change:options', (model) ->
      i = 0
      model.options.each (option) ->
        i++
        if option.attributes.value
          App.product_variants.each (variant) ->
            attr = {}
            attr["option#{i}"] = option.attributes.value
            variant.set attr, silent: true
      new App.Views.Product.Show.Variant.Index collection: App.product_variants
      $('#new-variant .cancel').click() # 如果新增款式表单已经显示,会显示旧的商品选项. issue#209

  toggleEdit: ->
    $('#product-edit').toggle()
    $('#product-right-col').toggle()
    $('#product').toggle()
    false

  showDuplicate: -> # 显示复制表单
    $('#duplicate-product').show()
    $('#duplicate_product_title').val("复制 #{@model.get('title')}").focus()
    false

  duplicate: -> # 复制
    title = $('#duplicate_product_title').val()
    flag = App.current_sku_size >= App.shop_sku_size
    if flag
      error_msg '商品唯一标识符超过商店限制'
      return
    if title
      $.post "/admin/products/#{@model.id}/duplicate", new_title: title, (data) ->
        window.location = "/admin/products/#{data.id}"
      , "json"
    false

  duplicateCancel: -> # 取消复制
    $('#duplicate-product').hide()
    false

  newVariant: -> # 新增款式
    new App.Views.Product.Show.Variant.New()
    $('#new-variant-link').hide()
    $('#new-variant').show()
    Utils.Effect.scrollTo('#new-variant')
    false

  show: (e) ->
    template = Handlebars.compile $('#product-image-item').html()
    url = $(e.target).closest('a').attr('href')
    $.blockUI message: template(title: '商品图片', url: url)
    false
