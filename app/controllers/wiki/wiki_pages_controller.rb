#encoding: utf-8
class Wiki::WikiPagesController < Wiki::AppController
  layout 'wiki'
  expose(:wiki){ WikiPage.wiki }

  def index
    @page = wiki.page('home')
    if @page
      render text: @page.formatted_data, layout: true
    else
      render text: "请创建<a href='/home'>wiki首页</a>", layout: true
    end
  end

  def create
    begin
      WikiPage.create params[:name],params[:format], params[:content],commit_message
      redirect_to "/#{CGI.escape(params[:name])}"
    rescue Gollum::DuplicatePageError => e
      @message = "页面重名了: #{e.message}"
      render text: @message, layout: true
    end
  end

  def show
    name = params[:name]
    show_page_or_file(name)
  end

  def edit
    @name = params[:name]
    page = wiki.page(@name)
    @format = page.format
    @content = page.raw_data
  end

  def preview
    @name = "Preview"
    @page = wiki.preview_page(@name, params[:content], params[:format])
    @content  = @page.formatted_data
    render :show
  end

  def update
    name   = params[:name]
    page   = wiki.page(name)
    format = params[:format] || :textile
    wiki.update_page(page, name, format.intern, params[:content], commit_message)
    redirect_to "/#{Gollum::Page.cname name}"
  end

  def destroy
    page   = wiki.page(params[:name])
    wiki.delete_page(page, commit_message)
    redirect_to '/'
  end

  def pages
    @results = wiki.pages
  end

  protected
  def show_page_or_file(name)
    if page = wiki.page(name)
      @page = page
      @name = name
      @content = page.formatted_data
      render :show
    else
      @name = params[:name]
      render :new
    end
  end

  private

  def commit_message
    { :message => params[:message] , :name => "liwh" , :email => "liwh87@gmail.com"}
  end

end
