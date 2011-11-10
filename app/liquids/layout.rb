class Layout < Liquid::Tag # 占位，暂不支持
  Syntax = /(#{Liquid::VariableSignature}+)/

  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @variable_name = $1
      @attributes = {}
    else
      raise SyntaxError.new("Syntax Error in 'layout' - Valid syntax: layout [name]")
    end
    super
  end

  def render(context)
    ''
  end

end
