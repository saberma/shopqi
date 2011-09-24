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

    def create(name,format = :textile,content,commit_message)
      wiki.write_page(name, format.intern, content, commit_message)
    end
  end

end
