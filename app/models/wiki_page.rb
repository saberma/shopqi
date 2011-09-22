class WikiPage

  class << self

    def path
      File.join(Rails.root,relative_path)
    end

    def relative_path
      '/wiki'
    end

    def wiki
      FileUtils.mkdir_p path
      Grit::Repo.init path
      Gollum::Wiki.new(path)
    end

    def create(name,format,content,commit_message)
      begin
        wiki.write_page(name, format, content, commit_message)
      rescue Gollum::DuplicatePageError => e
        "Duplicate page: #{e.message}"
      end
    end

    def update
    end
  end

end
