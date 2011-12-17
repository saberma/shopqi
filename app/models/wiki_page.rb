class WikiPage

  class << self

    def path
      File.join(Rails.root,relative_path)
    end

    def relative_path
      Setting.wiki.relative_path
    end

    def wiki
      unless File.exist?(path)
        FileUtils.mkdir_p path
        Grit::Repo.init path
      end
      Gollum::Wiki.new(path)
    end

  end

end
