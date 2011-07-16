class Form < Liquid::Block

  def initialize(tag_name,markup,tokens)
    @model_name = markup
    super
  end

  def render(context)
    @model_drop = context[@model_name] || nil
    #@model = @model_drop.instance_variable_get "@#{@model_name}"
    result = "<form method='post' action='/articles/#{@model_drop.id}/comments' id='article-#{@model_drop.id}-comment-form' class='comment-form'> "
    result += get_form_body(context)
    result += '</form>'
  end

  def get_form_body(context)
    context.stack do
      render_all(@nodelist, context) * ""
    end
  end

  def errors
    @model = context['article'] || nil
    get_errors(@model)
  end

  def get_errors(model)
    errors = []
    model.errors.each do |attr,msg|
      errors << attr
    end
    errors
  end

  def posted_successfully?
    errors.blank?
  end

end

